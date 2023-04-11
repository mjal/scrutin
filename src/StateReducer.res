// The reducer, the only place where state mutations can happen
let reducer = (state: State.t, action: StateMsg.t) => {
  switch action {

  | Reset =>
    (State.initial, [
      StateEffect.identities_fetch,
      StateEffect.trustees_fetch,
      StateEffect.contacts_fetch,
      StateEffect.eventsGetAndGoToUrl,
      StateEffect.importIdentityFromUrl,
    ])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [StateEffect.identities_store(ids)])

  | Event_Add(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [
      StateEffect.cache_update(event),
    ])

  | Event_Add_With_Broadcast(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [
      StateEffect.event_broadcast(event),
      StateEffect.cache_update(event),
    ])

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [StateEffect.trustees_store(trustees)])

  | Contact_Add(contact) =>
    let contacts = Array.concat(state.contacts, [contact])
    ({...state, contacts}, [StateEffect.contacts_store(contacts)])

  | Contact_Remove(index) =>
    let contacts = Array.keepWithIndex(state.contacts, (_, i) => i != index)
    ({...state, contacts}, [StateEffect.contacts_store(contacts)])

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
    (state, [StateEffect.language_store(language)])

  | Navigate(route) =>
    ({...state, route}, [])

  }
}


