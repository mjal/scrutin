// #### Description
// The database in an append-only log of signed events called **transactions**.

// ---

// #### Type
type t = {
  // **eventType**
  eventType: [#election | #ballot],
  // **event**: The stringified JSON representing the event
  event: string,
  // **eventHash**: hash(event)
  eventHash: string,
  // **publicKey**: The public key of the emitter of the event.<br />
  // Could be the election organizer or the voter
  publicKey: string,
  // **signature**: a signature of the eventHash from the emitter of the event.
  signature: string
}

// ---

// #### Utils

// Shorthand to hash a string and transform it to hex
let hash = (str) => {
  let baEventHash = Sjcl.Sha256.hash(str)
  Sjcl.Hex.fromBits(baEventHash)
}

// #### Election transactions
module SignedElection = {
  let make = (election : Election.t, owner : Identity.t) => {
    let event = Election.stringify(election)
    let eventHash = hash(event)
    {
      event,
      eventType: #election,
      eventHash,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, eventHash)
    }
  }

  let unwrap = (tx) : Election.t => {
    Election.parse(tx.event)
  }
}

// #### Ballot transactions
module SignedBallot = {
  let make = (ballot : Ballot.t, owner : Identity.t) => {
    let event = Ballot.stringify(ballot)
    let eventHash = hash(event)
    {
      event,
      eventType: #ballot,
      eventHash,
      publicKey: owner.hexPublicKey,
      signature: Identity.signHex(owner, eventHash)
    }
  }

  let unwrap = (tx) : Ballot.t => {
    Ballot.parse(tx.event)
  }
}

// #### Serialization
external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
external parse_array:     string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// #### Storage
let storageKey = "transactions"

let fetch_all = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  -> Promise.thenResolve(Js.Null.toOption)
  -> Promise.thenResolve(Option.map(_, parse_array))
  -> Promise.thenResolve(Option.getWithDefault(_, []))

let store_all = (txs) =>
  ReactNativeAsyncStorage.setItem(storageKey, stringify_array(txs)) -> ignore

let clear = () =>
  ReactNativeAsyncStorage.removeItem(storageKey) -> ignore
