// ## Cache management

let cacheUpdate = (ev: Event_.t, dispatch) => {
  switch ev.type_ {
  | #"election.create" =>
    dispatch(StateMsg.Cache_Election_Add(ev.cid, Event_.SignedElection.unwrap(ev)))
  | #"election.update" =>
    dispatch(StateMsg.Cache_Election_Add(ev.cid, Event_.SignedElection.unwrap(ev)))
  | #"ballot.create" => dispatch(StateMsg.Cache_Ballot_Add(ev.cid, Event_.SignedBallot.unwrap(ev)))
  | #"ballot.update" => dispatch(StateMsg.Cache_Ballot_Add(ev.cid, Event_.SignedBallot.unwrap(ev)))
  }
}

// ## LocalStorage - Store

let storeIdentities = (ids, _dispatch) => Account.store_all(ids)
let storeEvents = (evs, _dispatch) => Event_.store_all(evs)
let storeTrustees = (trustees, _dispatch) => Trustee.store_all(trustees)
let storeInvitations = (invitations, _dispatch) =>
  Invitation.store_all(invitations)
let storeLanguage = (language, _dispatch) =>
  ReactNativeAsyncStorage.setItem("config.language", language)->ignore

// ## LocalStorage - Load

let loadIdentities = dispatch => {
  Account.loadAll()
  ->Promise.thenResolve(ids => {
    Array.map(ids, id => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call storeIdentities as an effect...
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

let clearIdentities = _dispatch => Account.clear()
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
      let hexSecretKey = url.hash
      dispatch(StateMsg.Identity_Add(Account.make2(~hexSecretKey)))
    }
    dispatch(Navigate(url.path))
  }
}
