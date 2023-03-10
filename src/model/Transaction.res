// #### Description
// The database in an append-only log of signed events called **transactions**.

// ---

// #### Transaction.t
type t = {
  // **type**
  type_: [#election | #ballot],
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

// #### Election transactions
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

  let unwrap = (tx) : Election.t => {
    Election.parse(tx.content)
  }
}

// #### Ballot transactions
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

  let unwrap = (tx) : Ballot.t => {
    Ballot.parse(tx.content)
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
