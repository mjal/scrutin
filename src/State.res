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
  cachedElectionReplacementIds: Map.String.t<string>,
  cachedBallots:   Map.String.t<Ballot.t>,
  cachedBallotReplacementIds: Map.String.t<string>,
}

// The initial state of the application
let initial = {
  route: Election_Index,
  events: [],
  ids: [],
  trustees: [],
  contacts: [],
  cachedElections: Map.String.empty,
  cachedElectionReplacementIds: Map.String.empty,
  cachedBallots: Map.String.empty,
  cachedBallotReplacementIds: Map.String.empty,
}

let getBallotExn = (state, id) =>
  Map.String.getExn(state.cachedBallots, id)

let getElectionExn = (state, id) =>
  Map.String.getExn(state.cachedElections, id)
