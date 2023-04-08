// ## Cache management

let cache_update = (ev : Event_.t) =>
  (dispatch) => {
    switch ev.type_ {
    | #election => dispatch(StateMsg.Cache_Election_Add(ev.contentHash,
      Event_.SignedElection.unwrap(ev)))
    | #ballot => dispatch(StateMsg.Cache_Ballot_Add(ev.contentHash,
      Event_.SignedBallot.unwrap(ev)))
    | #tally => dispatch(StateMsg.Cache_Tally_Add(ev.contentHash,
      Event_.SignedTally.unwrap(ev)))
    }
  }

// ## LocalStorage - Store

let identities_store = (ids) => (_dispatch) => Identity.store_all(ids)
let events_store = (evs) => (_dispatch) => Event_.store_all(evs)
let trustees_store = (trustees) => (_dispatch) => Trustee.store_all(trustees)
let contacts_store = (contacts) => (_dispatch) => Contact.store_all(contacts)
let language_store = (language) =>
  (_dispatch) =>
    ReactNativeAsyncStorage.setItem("config.language", language) -> ignore

// ## LocalStorage - Fetch

let identities_fetch = (dispatch) => {
  Identity.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call identites_store as an effect...
  }) -> ignore
}

let events_fetch = (dispatch) => {
  Event_.fetch_all()
  -> Promise.thenResolve((evs) => {
    Array.map(evs, (ev) => dispatch(StateMsg.Event_Add(ev)))
  }) -> ignore
}

let trustees_fetch = (dispatch) => {
  Trustee.fetch_all()
  -> Promise.thenResolve((os) => {
    Array.map(os, (o) => dispatch(StateMsg.Trustee_Add(o)))
  }) -> ignore
}

let contacts_fetch = (dispatch) => {
  Contact.fetch_all()
  -> Promise.thenResolve((os) => {
    Array.map(os, (o) => dispatch(StateMsg.Contact_Add(o)))
  }) -> ignore
}

let language_fetch = () =>
  (_dispatch) =>
    ReactNativeAsyncStorage.getItem("config.language")
    -> Promise.thenResolve(Js.Null.toOption)
    -> Promise.thenResolve((language) => {
      switch language {
      | Some(language) =>
        let { i18n } = ReactI18next.useTranslation()
        i18n.changeLanguage(. language)
      | None => ()
      }
    }) -> ignore

// ## LocalStorage - Clear

let identities_clear = (_dispatch) => Identity.clear()
let events_clear = (_dispatch) => Event_.clear()
let trustees_clear = (_dispatch) => Trustee.clear()

// ## Network - Get

let eventsGetAndGoToUrl = (dispatch) => {
  Webapi.Fetch.fetch(j`${URL.api_url}/transactions`)
  -> Promise.then(Webapi.Fetch.Response.json)
  -> Promise.thenResolve(response => {
    switch Js.Json.decodeArray(response) {
      | Some(jsons) => {
        let _ = Array.map(jsons, (json) => {
          let ev = Event_.from_json(json)
          dispatch(StateMsg.Event_Add(ev))
          ()
        })
        ()
      }
      | None => ()
    }
  })
  -> Promise.thenResolve(_ => {
    URL.getAndThen((url) => {
      switch url {
      | list{"ballots", id} =>
        dispatch(StateMsg.Navigate(Ballot_Show(id)))
      | list{"elections", id} =>
        dispatch(StateMsg.Navigate(Election_Show(id)))
      | _ => ()
      }
    })
  })
  -> ignore
}

let identities_get = (dispatch) => {
  Identity.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call identites_store as an effect...
  }) -> ignore
}

// ## Send event to the server
let event_broadcast = (ev) =>
  (_dispatch) => {
    Event_.broadcast(ev) -> ignore
  }

// ## Save secret keys passed by url #hash

let importIdentityFromUrl = (dispatch) => {
  if String.length(URL.getCurrentHash()) > 12 {
    let currentHash = URL.getCurrentHash()
    let hexSecretKey = String.sub(currentHash, 1,
      String.length(currentHash) - 1)
    dispatch(StateMsg.Identity_Add(Identity.make2(~hexSecretKey)))
  }
}
