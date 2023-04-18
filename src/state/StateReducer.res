// The reducer, the only place where state mutations can happen
let reducer = (state: State.t, action: StateMsg.t) => {
  switch action {

  | Reset =>
    (State.initial, [
      StateEffect.fetchIdentities,
      StateEffect.fetchTrustees,
      StateEffect.fetchContacts,
      StateEffect.getEvents,
      StateEffect.goToUrl
    ])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [StateEffect.storeIdentities(ids)])

  | Event_Add(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [
      StateEffect.cacheUpdate(event),
    ])

  | Event_Add_With_Broadcast(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [
      StateEffect.broadcastEvent(event),
      StateEffect.cacheUpdate(event),
    ])

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [StateEffect.storeTrustees(trustees)])

  | Contact_Add(contact) =>
    let contacts = Array.concat(state.contacts, [contact])
    ({...state, contacts}, [StateEffect.storeContacts(contacts)])

  | Contact_Remove(index) =>
    let contacts = Array.keepWithIndex(state.contacts, (_, i) => i != index)
    ({...state, contacts}, [StateEffect.storeContacts(contacts)])

  | Cache_Election_Add(cid, election) =>
    let elections =
      Map.String.set(state.elections, cid, election)
    let electionReplacementIds = switch election.previousId {
    | Some(previousId) =>
      Map.String.set(state.electionReplacementIds,
        previousId, cid)
    | None => state.electionReplacementIds
    }
    ({...state, elections, electionReplacementIds}, [])

  | Cache_Ballot_Add(cid, ballot) =>
    let ballots =
      Map.String.set(state.ballots, cid, ballot)
    let ballotReplacementIds = switch ballot.previousId {
    | Some(previousId) =>
      Map.String.set(state.ballotReplacementIds,
        previousId, cid)
    | None => state.electionReplacementIds
    }
    ({...state, ballots, ballotReplacementIds}, [])

  | Config_Store_Language(language) =>
    (state, [StateEffect.storeLanguage(language)])

  | Navigate(route) =>
    if ReactNative.Platform.os == #web {
      if (route != RescriptReactRouter.dangerouslyGetInitialUrl().path) {
        let path = Belt.List.reduce(route, "", (a, b) => a ++ "/" ++ b)
        let path = if path == "" { "/" } else { path }
        RescriptReactRouter.push(path)
      }
    }
    ({...state, route}, [])

  | Navigate_Back =>
    if ReactNative.Platform.os == #web {
      let () = %raw(`history.back()`)
      (state, [])
    } else {
      // At the moment we directly go home on mobile, as we don't store history
      ({...state, route: list{}}, [])
    }
  }
}

