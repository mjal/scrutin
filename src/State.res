// The state of the application.

type t = {
  // See [[Event]]
  events: array<Event_.t>,

  // The controlled identities (as voter or election organizer)
  // See [[Identity]]
  ids: array<Identity.t>,

  // The controlled election private key (for tallying)
  // See [[Trustee]]
  trustees: array<Trustee.t>,

  // Contacts, to keep track on who is associated with which public key
  contacts: array<Contact.t>,

  // The current route (still waiting for a decent rescript router
  // that works on web and native)
  route: Route.t,

  // Cache of elections and ballot for fast lookup
  cachedElections: Map.String.t<Election.t>,
  cachedBallots:   Map.String.t<Ballot.t>,
}

// The initial state of the application
let initial = {
  route: Election_Index,
  events: [],
  ids: [],
  trustees: [],
  contacts: [],
  cachedElections: Map.String.empty,
  cachedBallots: Map.String.empty,
}

// The reducer, the only place where state mutations can happen
let reducer = (state, action: StateMsg.t) => {
  switch action {

  | Reset =>
    (initial, [
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
    ({...state, cachedElections}, [])

  | Cache_Ballot_Add(contentHash, ballot) =>
    let cachedBallots =
      Map.String.set(state.cachedBallots, contentHash, ballot)
    ({...state, cachedBallots}, [])

  | Config_Store_Language(language) =>
    (state, [StateEffect.language_store(language)])

  | Navigate(route) =>
    ({...state, route}, [])

  }
}

let getBallot   = (state, id) => Map.String.getExn(state.cachedBallots, id)
let getElection = (state, id) => Map.String.getExn(state.cachedElections, id)
