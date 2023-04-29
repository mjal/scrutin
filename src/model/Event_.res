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
  let parse = (ev): Election.t => { Election.parse(ev.content) }
}

module ElectionBallot = {
  let create = (ballot: Ballot.t, voter: Account.t) => {
    makeEvent(#"election.ballot", Ballot.stringify(ballot), voter)
  }
  let parse = (ev): Ballot.t => { Ballot.parse(ev.content) }
}

module ElectionVoter = {
  type t = { electionId: string, voterId: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, admin: Account.t) => {
    makeEvent(#"election.voter", stringify(payload), admin)
  }
}

module ElectionTally = {
  type t = { electionId: string, pda: string, pdb: string, result: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, admin: Account.t) => {
    makeEvent(#"election.tally", stringify(payload), admin)
  }
}

module ElectionDelegate = {
  type t = { electionId: string, voterId: string, delegateId: string }
  external parse: string => t = "JSON.parse"
  external stringify: t => string = "JSON.stringify"
  let create = (payload: t, voter: Account.t) => {
    makeEvent(#"election.delegation", stringify(payload), voter)
  }
}

// #### Unsafe Serialization
external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"
external parse_array: string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// #### Safe serialization
let from_json = json => {
  open Json.Decode
  let decode = object(field => {
    let type_str = field.required(. "type_", string)
    switch Array.getBy(event_type_map, ((_, str)) => str == type_str) {
    | Some((variant_type, _)) =>
      {
        type_: variant_type,
        content: field.required(. "content", string),
        cid: field.required(. "cid", string),
        emitterId: field.required(. "emitterId", string),
        signature: field.required(. "signature", string),
      }
    | _ => Js.Exn.raiseError("Unknown event type")
    }
  })
  switch json->Json.decode(decode) {
  | Ok(result) => result
  | Error(error) => raise(DecodeError({error}))
  }
}

let to_json = (r: t): Js.Json.t => {
  open! Json.Encode
  switch Array.getBy(event_type_map, ((variant, _)) => variant == r.type_) {
  | Some((_, str_type)) =>
    Unsafe.object({
      "type_": str_type,
      "content": string(r.content),
      "cid": string(r.cid),
      "emitterId": string(r.emitterId),
      "signature": string(r.signature),
    })
  | None => Js.Exn.raiseError("Unknown event type")
  }
}

// #### Storage
let storageKey = "events"

let loadAll = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(Option.map(_, parse_array))
  ->Promise.thenResolve(Option.getWithDefault(_, []))

let store_all = evs => ReactNativeAsyncStorage.setItem(storageKey, stringify_array(evs))->ignore

let clear = () => ReactNativeAsyncStorage.removeItem(storageKey)->ignore

let broadcast = ev => {
  X.post(`${URL.bbs_url}/events`, to_json(ev))
}
