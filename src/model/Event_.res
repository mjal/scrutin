// #### Description
// Every state mutation is done through events

// ---
type event_type_t = [
  | #"election"
  | #"election.update"
  | #"ballot"
]

// #### Event.t
type t = {
  // **type**
  type_: event_type_t,
  // **content**: The stringified JSON representing the state mutation
  content: string,
  // **cid**: hash(content)
  cid: string,
  // **publicKey**: The public key of the emitter of the event.<br />
  // Could be the election organizer or the voter
  publicKey: string,
  // **signature**: a signature of the cid from the emitter.
  signature: string,
}

// ---

// #### Utils

// Shorthand to hash a string and transform it to hex
let hash = str => {
  let baEventHash = Sjcl.Sha256.hash(str)
  Sjcl.Hex.fromBits(baEventHash)
}

// #### Election events
module SignedElection = {
  let make = (type_: event_type_t, election: Election.t, owner: Account.t) => {
    let content = Election.stringify(election)
    let cid = hash(content)
    {
      content,
      type_,
      cid,
      publicKey: owner.userId,
      signature: Account.signHex(owner, cid),
    }
  }

  type create = (Election.t, Account.t) => t
  let create = make(#"election")

  type update = (Election.t, Account.t) => t
  let update = make(#"election.update")

  let unwrap = (ev): Election.t => {
    Election.parse(ev.content)
  }
}

// #### Ballot events
module SignedBallot = {
  let create = (ballot: Ballot.t, owner: Account.t) => {
    let content = Ballot.stringify(ballot)
    let cid = hash(content)
    {
      type_: #"ballot",
      content,
      cid,
      publicKey: owner.userId,
      signature: Account.signHex(owner, cid),
    }
  }

  let unwrap = (ev): Ballot.t => {
    Ballot.parse(ev.content)
  }
}

/*
// #### Tally event
module SignedTally = {
  let make = (tally : ElectionTally.t, owner : Identity.t) => {
    let content = ElectionTally.stringify(tally)
    let cid = hash(content)
    {
      content,
      type_: #tally,
      cid,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, cid)
    }
  }

  let unwrap = (ev) : ElectionTally.t => {
    ElectionTally.parse(ev.content)
  }
}
*/

// #### Helpers
let event_type_t_to_s = type_ => {
  switch type_ {
  | #"election" => "election"
  | #"election.update" => "election.update"
  | #"ballot" => "ballot"
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
    let type_ = switch field.required(. "type_", string) {
    | "election" => #"election"
    | "election.update" => #"election.update"
    | "ballot" => #"ballot"
    | _ => Js.Exn.raiseError("Unknown event type")
    }
    {
      type_,
      content: field.required(. "content", string),
      cid: field.required(. "cid", string),
      publicKey: field.required(. "publicKey", string),
      signature: field.required(. "signature", string),
    }
  })
  switch json->Json.decode(decode) {
  | Ok(result) => result
  | Error(error) => raise(DecodeError({error}))
  }
}

let to_json = (r: t): Js.Json.t => {
  open! Json.Encode
  let type_ = event_type_t_to_s(r.type_)
  Unsafe.object({
    "type_": type_,
    "content": string(r.content),
    "cid": string(r.cid),
    "publicKey": string(r.publicKey),
    "signature": string(r.signature),
  })
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
  X.post(`${URL.api_url}/events`, to_json(ev))
}
