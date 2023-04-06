// #### Description
// The database in an append-only log of signed events

// ---

// #### Event.t
type t = {
  // **type**
  type_: [#election | #ballot | #tally],
  // **content**: The stringified JSON representing the state mutation
  content: string,
  // **contentHash**: hash(content)
  contentHash: string,
  // **publicKey**: The public key of the emitter of the event.<br />
  // Could be the election organizer or the voter
  publicKey: string,
  // **signature**: a signature of the contentHash from the emitter.
  signature: string
}

// ---

// #### Utils

// Shorthand to hash a string and transform it to hex
let hash = (str) => {
  let baEventHash = Sjcl.Sha256.hash(str)
  Sjcl.Hex.fromBits(baEventHash)
}

// #### Election events
module SignedElection = {
  let make = (election : Election.t, owner : Identity.t) => {
    let content = Election.stringify(election)
    let contentHash = hash(content)
    {
      content,
      type_: #election,
      contentHash,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, contentHash)
    }
  }

  let unwrap = (ev) : Election.t => {
    Election.parse(ev.content)
  }
}

// #### Ballot events
module SignedBallot = {
  let make = (ballot : Ballot.t, owner : Identity.t) => {
    let content = Ballot.stringify(ballot)
    let contentHash = hash(content)
    {
      content,
      type_: #ballot,
      contentHash,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, contentHash)
    }
  }

  let unwrap = (ev) : Ballot.t => {
    Ballot.parse(ev.content)
  }
}

// #### Tally event
module SignedTally = {
  let make = (tally : ElectionTally.t, owner : Identity.t) => {
    let content = ElectionTally.stringify(tally)
    let contentHash = hash(content)
    {
      content,
      type_: #tally,
      contentHash,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, contentHash)
    }
  }

  let unwrap = (ev) : ElectionTally.t => {
    ElectionTally.parse(ev.content)
  }
}

// #### Unsafe Serialization
external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
external parse_array:     string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// #### Safe serialization
let from_json = (json) => {
  open Json.Decode
  let decode = object(field => {
    let type_ = switch field.required(. "type_", string) {
    | "election" => #election
    | "ballot" => #ballot
    | "tally" => #tally
    | _ => Js.Exn.raiseError("Unknown event type")
    }
    {
      type_,
      content: field.required(. "content", string),
      contentHash: field.required(. "contentHash", string),
      publicKey: field.required(. "publicKey", string),
      signature: field.required(. "signature", string),
    }
  })
  switch (json->Json.decode(decode)) {
    | Ok(result) => result
    | Error(error) => {
      raise(DecodeError({error}))
    }
  }
}

let to_json = (r: t) : Js.Json.t => {
  open! Json.Encode
  let type_ = switch r.type_ {
  | #election => "election"
  | #ballot => "ballot"
  | #tally => "tally"
  }
  Unsafe.object({
    "type_": type_,
    "content": string(r.content),
    "contentHash": string(r.contentHash),
    "publicKey": string(r.publicKey),
    "signature": string(r.signature),
  })
}


// #### Storage
let storageKey = "events"

let fetch_all = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  -> Promise.thenResolve(Js.Null.toOption)
  -> Promise.thenResolve(Option.map(_, parse_array))
  -> Promise.thenResolve(Option.getWithDefault(_, []))

let store_all = (evs) =>
  ReactNativeAsyncStorage.setItem(storageKey, stringify_array(evs)) -> ignore

let clear = () =>
  ReactNativeAsyncStorage.removeItem(storageKey) -> ignore

let broadcast = (ev) => {
  X.post(`${URL.api_url}/transactions`, to_json(ev))
}
