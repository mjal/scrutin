let electionsUpdate =  (
  elections: Map.String.t<Election.t>,
  ballots: array<Ballot.t>,
  ev: Event_.t
) => {
  switch ev.type_ {
  | #"election.init" =>
    let election = Event_.ElectionInit.parse(ev)
    let election = {...election,
      electionId: Some(ev.cid)
    }
    let elections = Map.String.set(elections, ev.cid, election)
    (elections, ballots)
  | #"election.voter" =>
    let {electionId, voterId} = Event_.ElectionVoter.parse(ev.content)
    switch Map.String.get(elections, electionId) {
    | None =>
      Js.log(("Cannot find election", electionId))
      (elections, ballots)
    | Some(election) =>
      let election = {
        ...election,
        voterIds: Array.concat(election.voterIds, [voterId])
      }
      let elections = Map.String.set(elections, electionId, election)
      (elections, ballots)
    }
  | #"election.delegation" =>
    let {electionId, voterId, delegateId} = Event_.ElectionDelegate.parse(ev.content)
    switch Map.String.get(elections, electionId) {
    | None =>
      Js.log(("Cannot find election", electionId))
      (elections, ballots)
    | Some(election) =>
      let voterIds = election.voterIds->Array.map((userId) => {
        if userId == voterId { delegateId } else { userId }
      })
      Js.log((election.voterIds, voterId, voterIds))
      let election = { ...election, voterIds }
      let elections = Map.String.set(elections, electionId, election)
      (elections, ballots)
    }
  | #"election.ballot" =>
    let ballot = Event_.ElectionBallot.parse(ev)
    (elections, Array.concat(ballots, [ballot]))
  | #"election.tally" =>
    let { electionId, pda, pdb, result } = Event_.ElectionTally.parse(ev.content)
    switch Map.String.get(elections, electionId) {
    | None =>
      Js.log(("Cannot find election", electionId))
      (elections, ballots)
    | Some(election) =>
      let election = {
        ...election,
        pda: Some(pda),
        pdb: Some(pdb),
        result: Some(result)
      }
      let elections = Map.String.set(elections, electionId, election)
      (elections, ballots)
    }
  }
}

// ## LocalStorage - Store

let storeAccounts = (ids, _dispatch) => Account.store_all(ids)
let storeEvents = (evs, _dispatch) => Event_.store_all(evs)
let storeTrustees = (trustees, _dispatch) => Trustee.store_all(trustees)
let storeInvitations = (invitations, _dispatch) =>
  Invitation.store_all(invitations)
let storeLanguage = (language, _dispatch) =>
  ReactNativeAsyncStorage.setItem("config.language", language)->ignore

// ## LocalStorage - Load

let loadAccounts = dispatch => {
  Account.loadAll()
  ->Promise.thenResolve(accounts => {
    Array.map(accounts, account => dispatch(StateMsg.Account_Add(account)))
    // FIX: Account_Add call storeAccount as an effect...
  })
  ->ignore
}

let loadEvents = dispatch => {
  Event_.loadAll()
  ->Promise.thenResolve(evs => {
    Array.map(evs, ev => dispatch(StateMsg.Event_Add(ev)))
  })
  ->ignore
}

let loadTrustees = dispatch => {
  Trustee.loadAll()
  ->Promise.thenResolve(os => {
    Array.map(os, o => dispatch(StateMsg.Trustee_Add(o)))
  })
  ->ignore
}

let loadInvitations = dispatch => {
  Invitation.loadAll()
  ->Promise.thenResolve(os => {
    Array.map(os, o => dispatch(StateMsg.Invitation_Add(o)))
  })
  ->ignore
}

let loadLanguage = ((), _dispatch) =>
  ReactNativeAsyncStorage.getItem("config.language")
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(language => {
    switch language {
    | Some(language) =>
      let {i18n} = ReactI18next.useTranslation()
      i18n.changeLanguage(. language)
    | None => ()
    }
  })
  ->ignore

// ## LocalStorage - Clear

let clearAccounts = _dispatch => Account.clear()
let clearEvents = _dispatch => Event_.clear()
let clearTrustees = _dispatch => Trustee.clear()

// ## Network - Fetch
let loadAndFetchEvents = dispatch => {
  Event_.loadAll()
  ->Promise.thenResolve(evs => {
    Array.forEach(evs, ev => dispatch(StateMsg.Event_Add(ev)))
    evs
  })
  ->Promise.thenResolve(evs => {
    Js.log(evs)
    let latestId = evs->Array.reduce(0, (acc, ev:Event_.t) => acc > ev.id ? acc : ev.id)
    Webapi.Fetch.fetch(`${URL.bbs_url}/events?from=${latestId->Int.toString}`)
    ->Promise.then(Webapi.Fetch.Response.json)
    ->Promise.thenResolve(response => {
      switch Js.Json.decodeArray(response) {
      | Some(jsons) =>
        Array.forEach(jsons, json => {
          try {
            dispatch(StateMsg.Event_Add(Event_.from_json(json)))
          } catch {
          | _ => Js.log("Cannot parse event")
          }
        })
        dispatch(StateMsg.Fetched)
      | None => ()
      }
    })
  })
  ->ignore
}

let fetchLatestEvents = (latestId, dispatch) => {
  Webapi.Fetch.fetch(`${URL.bbs_url}/events?from=${latestId->Int.toString}`)
  ->Promise.then(Webapi.Fetch.Response.json)
  ->Promise.thenResolve(response => {
    switch Js.Json.decodeArray(response) {
    | Some(jsons) =>
      Array.forEach(jsons, json => {
        try {
          dispatch(StateMsg.Event_Add(Event_.from_json(json)))
        } catch {
        | _ => Js.log("Cannot parse event")
        }
      })
      dispatch(StateMsg.Fetched)
    | None => ()
    }
  })->ignore
}

// ## Send event to the server
let broadcastEvent = (ev, _dispatch) => {
  Event_.broadcast(ev)->ignore
}

let goToUrl = dispatch => {
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
    dispatch(StateMsg.Navigate(url.path))
  }
}
