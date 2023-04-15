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

  | Cache_Election_Add(contentHash, election) =>
    let cachedElections =
      Map.String.set(state.cachedElections, contentHash, election)
    let cachedElectionReplacementIds = switch election.previousId {
    | Some(previousId) =>
      Map.String.set(state.cachedElectionReplacementIds,
        previousId, contentHash)
    | None => state.cachedElectionReplacementIds
    }
    ({...state, cachedElections, cachedElectionReplacementIds}, [])

  | Cache_Ballot_Add(contentHash, ballot) =>
    let cachedBallots =
      Map.String.set(state.cachedBallots, contentHash, ballot)
    let cachedBallotReplacementIds = switch ballot.previousId {
    | Some(previousId) =>
      Map.String.set(state.cachedBallotReplacementIds,
        previousId, contentHash)
    | None => state.cachedElectionReplacementIds
    }
    ({...state, cachedBallots, cachedBallotReplacementIds}, [])

  | Config_Store_Language(language) =>
    (state, [StateEffect.storeLanguage(language)])

  | Navigate(route) =>
    if ReactNative.Platform.os == #web {
      let path = Belt.List.reduce(route, "", (a, b) => a ++ "/" ++ b)
      let path = if path == "" { "/" } else { path }
      RescriptReactRouter.push(path)
    }
    ({...state, route}, [])

  }
}

