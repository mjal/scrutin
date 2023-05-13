// #### Description
// State mutations are done through events

// #### Event types
type event_type_t = [
  | #"election.init"
  | #"election.voter"
  | #"election.delegation"
  | #"election.ballot"
  | #"election.tally"
]

let event_type_map : array<(event_type_t, string)> = [
    (#"election.init", "election.init"),
    (#"election.voter", "election.voter"),
    (#"election.delegation", "election.delegation"),
    (#"election.ballot", "election.ballot"),
    (#"election.tally", "election.tally")
  ]

// #### Event.t
type t = {
  // **type**
  type_: event_type_t,
  // **content**: The stringified JSON representing the state mutation
  content: string,
  // **cid**: hash(content)
  cid: string,
  // **emitterId**: The emitter of the event.<br />
  // Depending on the event, it can be a voter or an admin
  emitterId: string,
  // **signature**: the emitter's digital signature
  signature: string,
}

// ---

// #### Utils
// Shorthand to hash a string and transform it to hex
let hash = str => {
  let baEventHash = Sjcl.Sha256.hash(str)
  Sjcl.Hex.fromBits(baEventHash)
}

let makeEvent = (type_, content, account: Account.t) => {
  let cid = hash(content)
  let emitterId = account.userId
  let signature = account->Account.signHex(cid)
  { type_, content, cid, emitterId, signature }
}

module ElectionInit = {
  let create = (election: Election.t, admin: Account.t) => {
    makeEvent(#"election.init", Election.stringify(election), admin)
  }
  let unwrap = (ev): Election.t => {
    Election.parse(ev.content)
  }
}

module ElectionBallot = {
  let create = (ballot: Ballot.t, voter: Account.t) => {
    makeEvent(#"election.ballot", Ballot.stringify(ballot), voter)
  }
  let unwrap = (ev): Ballot.t => {
    Ballot.parse(ev.content)
  }
}

module ElectionVoter = {
  type t = { electionId: string, voterId: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, admin: Account.t) => {
    makeEvent(#"election.voter", stringify(payload), admin)
  }
  let unwrap = (ev): t => { parse(ev.content) }
}

module ElectionTally = {
  type t = { electionId: string, pda: string, pdb: string, result: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, admin: Account.t) => {
    makeEvent(#"election.tally", stringify(payload), admin)
  }
  let unwrap = (ev): t => { parse(ev.content) }
}

module ElectionDelegate = {
  type t = { electionId: string, voterId: string, delegateId: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, voter: Account.t) => {
    makeEvent(#"election.delegation", stringify(payload), voter)
  }
  let unwrap = (ev): t => { parse(ev.content) }
}

// #### Unsafe Serialization
external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"
external parse_array: string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"
