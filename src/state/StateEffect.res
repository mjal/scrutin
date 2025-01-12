// ## LocalStorage - Store

let storeAccounts = async (ids, _dispatch) => Account.store_all(ids)
//let storeEvents = async (evs, _dispatch) => Event_.store_all(evs)
//let storeTrustees = async (trustees, _dispatch) => Trustee.store_all(trustees)
let storeInvitations = async (invitations, _dispatch) =>
  Invitation.store_all(invitations)
let storeLanguage = async (language, _dispatch) =>
  ReactNativeAsyncStorage.setItem("config.language", language)->ignore

// ## LocalStorage - Load

let loadAccounts = async dispatch => {
  Account.loadAll()
  ->Promise.thenResolve(accounts => {
    Array.map(accounts, account => dispatch(StateMsg.Account_Add(account)))
    // FIX: Account_Add call storeAccount as an effect...
  })
  ->ignore
}

//let loadEvents = dispatch => {
//  Event_.loadAll()
//  ->Promise.thenResolve(evs => {
//    Array.map(evs, ev => dispatch(StateMsg.Event_Add(ev)))
//  })
//  ->ignore
//}

//let loadTrustees = async dispatch => {
//  Trustee.loadAll()
//  ->Promise.thenResolve(os => {
//    Array.map(os, o => dispatch(StateMsg.Trustee_Add(o)))
//  })
//  ->ignore
//}

let loadInvitations = async dispatch => {
  Invitation.loadAll()
  ->Promise.thenResolve(os => {
    Array.map(os, o => dispatch(StateMsg.Invitation_Add(o)))
  })
  ->ignore
}

let loadLanguage = async ((), _dispatch) =>
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

let clearAccounts = async _dispatch => Account.clear()
//let clearEvents = async _dispatch => Event_.clear()
//let clearTrustees = async _dispatch => Trustee.clear()

//// ## Network - Fetch
//let loadAndFetchEvents = async dispatch => {
//  Event_.loadAll()
//  ->Promise.thenResolve(evs => {
//    Array.forEach(evs, ev => dispatch(StateMsg.Event_Add(ev)))
//    evs
//  })
//  ->Promise.thenResolve(evs => {
//    Js.log(evs)
//    let latestId = evs->Array.reduce(0, (acc, ev:Event_.t) => acc > ev.id ? acc : ev.id)
//    Webapi.Fetch.fetch(`${URL.bbs_url}/events?from=${latestId->Int.toString}`)
//    ->Promise.then(Webapi.Fetch.Response.json)
//    ->Promise.thenResolve(response => {
//      switch Js.Json.decodeArray(response) {
//      | Some(jsons) =>
//        Array.forEach(jsons, json => {
//          try {
//            dispatch(StateMsg.Event_Add(Event_.from_json(json)))
//          } catch {
//          | _ => Js.log("Cannot parse event")
//          }
//        })
//        dispatch(StateMsg.Fetched)
//      | None => ()
//      }
//    })
//  })
//  ->ignore
//}

//let fetchLatestEvents = async (latestId, dispatch) => {
//  Webapi.Fetch.fetch(`${URL.bbs_url}/events?from=${latestId->Int.toString}`)
//  ->Promise.then(Webapi.Fetch.Response.json)
//  ->Promise.thenResolve(response => {
//    switch Js.Json.decodeArray(response) {
//    | Some(jsons) =>
//      Array.forEach(jsons, json => {
//        try {
//          dispatch(StateMsg.Event_Add(Event_.from_json(json)))
//        } catch {
//        | _ => Js.log("Cannot parse event")
//        }
//      })
//      dispatch(StateMsg.Fetched)
//    | None => ()
//    }
//  })->ignore
//}

//// ## Send event to the server
//let broadcastEvent = async (ev, _dispatch) => {
//  Event_.broadcast(ev)->ignore
//}

let goToUrl = async dispatch => {
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
    dispatch(StateMsg.Navigate(url.path))
  }
}

let uploadBallot = async (name, election: Election.t, ballot: Ballot.t, dispatch) => {
  let obj: Js.Json.t = Js.Json.object_(Js.Dict.fromArray([
    ("name", Js.Json.string(name)),
    ("ballot", Ballot.toJSON(ballot)),
    ("election_uuid", Js.Json.string(election.uuid))
  ]))
  let _response = await X.post(`${URL.bbs_url}/${election.uuid}/ballots`, obj)
  dispatch(StateMsg.Navigate(list{"elections", election.uuid, "avote"}))
}

let sendEmailsAndCreateElection = async (emails, election: Election.t, trustees, credentials, dispatch) => {
  let _ = (trustees, credentials, dispatch)
  let emails = Array.map(emails, email => Js.Json.string(email))
  let obj: Js.Json.t = Js.Json.object_(Js.Dict.fromArray([
    ("uuid", Js.Json.string(election.uuid)),
    ("emails", Js.Json.array(emails)),
  ]))
  let response = await X.post(`${URL.registrar_url}/send-keys`, obj)
  Js.log(response)
}

type res_t = {
  success: bool,
  setup: Setup.serialized_t,
  ballots: array<Ballot.t>,
  encryptedTally: Js.null<EncryptedTally.t>,
  partialDecryptions: array<PartialDecryption.t>,
  result: Js.null<Result_.t>
}
let fetchElection = async (uuid, dispatch) => {
  let response = await Webapi.Fetch.fetch(`${URL.bbs_url}/${uuid}`)
  switch Webapi.Fetch.Response.ok(response) { 
  | false =>
    Js.log("Can't find election")
  | true =>
    let json = await Webapi.Fetch.Response.json(response)
    let res : res_t = Obj.magic(json)
    let {
      setup,
      ballots,
      encryptedTally,
      partialDecryptions,
      result
    } = res
    let electionData = ElectionData.parse({
      setup,
      ballots,
      encryptedTally: Js.Null.toOption(encryptedTally),
      partialDecryptions,
      result: Js.Null.toOption(result)
    })
    Js.log(1)
    Js.log(electionData)
    Js.log(2)
    dispatch(StateMsg.ElectionData_Set(uuid, electionData))
  }
}
