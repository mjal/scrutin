// The state of the application.

type t = {
  // See [[Event]].
  // We use this to populate elections and ballots
  events: array<Event_.t>,

  // The controlled identities (as voter or election organizer)
  // See [[Identity]]
  ids: array<Account.t>,

  // The controlled election private key (for tallying)
  // See [[Trustee]]
  trustees: array<Trustee.t>,

  // Contacts, to keep track on who is associated with which public key
  contacts: array<Contact.t>,

  // The current route (still waiting for a decent rescript router
  // that works on web and native)
  route: list<string>,

  // elections and ballot (from parsed events)
  elections: Map.String.t<Election.t>,
  electionReplacementIds: Map.String.t<string>,
  ballots:   Map.String.t<Ballot.t>,
  ballotReplacementIds: Map.String.t<string>,
}

// The initial state of the application
let initial = {
  route: list{""},
  events: [],
  ids: [],
  trustees: [],
  contacts: [],
  elections: Map.String.empty,
  electionReplacementIds: Map.String.empty,
  ballots: Map.String.empty,
  ballotReplacementIds: Map.String.empty,
}

let getBallot = (state, id) => Map.String.get(state.ballots, id)
let getBallotExn = (state, id) => Map.String.getExn(state.ballots, id)
let getElection = (state, id) => Map.String.get(state.elections, id)
let getElectionExn = (state, id) =>
  Map.String.getExn(state.elections, id)
let getAccount = (state, publicKey) =>
  Array.getBy(state.ids, (id) => publicKey == id.hexPublicKey)
let getAccountExn = (state, publicKey) =>
  getAccount(state, publicKey) -> Option.getExn

let rec getBallotOriginalId = (state, ballotId) => {
  let ballot = state->getBallotExn(ballotId)
  switch ballot.previousId {
  | Some(previousId) => state->getBallotOriginalId(previousId)
  | None => ballotId
  }
}

let countVotes = (state, electionId) => {
  Map.String.toArray(state.ballots)
  -> Array.keep(((_id, ballot)) =>
    ballot.electionId == electionId)
  -> Array.keep(((id, _ballot)) => {
    Map.String.get(state.ballotReplacementIds, id)
    -> Option.isNone
  })
  -> Array.keep(((_id, ballot)) => {
    Option.isSome(ballot.ciphertext)
  })
  -> Js.Array2.map(((id, ballot)) => {
    (state->getBallotOriginalId(id), ballot)
  })
  -> Js.Dict.fromArray
  -> Js.Dict.values
  -> Array.length
}

