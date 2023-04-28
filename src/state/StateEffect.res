let electionsUpdate =  (elections: Map.String.t<Election.t>, ev: Event_.t, dispatch) => {
  switch ev.type_ {
  | #"election.init" =>
    let election = Event_.ElectionInit.unwrap(ev)
    dispatch(StateMsg.ElectionInit(ev.cid, election))
  | #"election.voter" =>
    let {electionId, voterId} = Event_.ElectionVoter.parse(ev.content)
    let election = Map.String.getExn(elections, electionId)
    dispatch(StateMsg.ElectionUpdate(ev.cid, {
      ...election,
      voterIds: Array.concat(election.voterIds, [voterId])
    }))
  | #"election.delegation" =>
    let {electionId, voterId, delegateId} = Event_.ElectionDelegate.parse(ev.content)
    let election = Map.String.getExn(elections, electionId)
    let voterIds = election.voterIds->Array.map((userId) => {
      if userId == voterId { delegateId } else { voterId }
    })
    dispatch(StateMsg.ElectionUpdate(ev.cid, { ...election, voterIds }))
  | #"election.ballot" =>
    let ballot = Event_.ElectionBallot.unwrap(ev)
    dispatch(StateMsg.BallotAdd(ev.cid, ballot))
  | #"election.tally" =>
    let { electionId, pda, pdb, result } = Event_.ElectionTally.parse(ev.content)
    let election = Map.String.getExn(elections, electionId)
    dispatch(StateMsg.ElectionUpdate(ev.cid, {
      ...election,
      pda: Some(pda),
      pdb: Some(pdb),
      result: Some(result)
    }))
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

let fetchEvents = dispatch => {
  Webapi.Fetch.fetch(`${URL.api_url}/events`)
  ->Promise.then(Webapi.Fetch.Response.json)
  ->Promise.thenResolve(response => {
    switch Js.Json.decodeArray(response) {
    | Some(jsons) => {
        let _ = Array.map(jsons, json => {
          try {
            let ev = Event_.from_json(json)
            dispatch(StateMsg.Event_Add(ev))
          } catch {
          | _ => Js.log("Cannot parse event")
          }
          ()
        })
        dispatch(StateMsg.Fetching_Events_End)
      }
    | None => ()
    }
  })
  ->ignore
}

// ## Send event to the server
let broadcastEvent = (ev, _dispatch) => {
  Event_.broadcast(ev)->ignore
}

let goToUrl = dispatch => {
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
    if String.length(url.hash) > 12 {
      let secret = url.hash
      dispatch(StateMsg.Account_Add(Account.make2(~secret)))
    }
    dispatch(Navigate(url.path))
  }
}
