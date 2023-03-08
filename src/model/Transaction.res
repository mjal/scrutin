type t = {
  event: string,
  eventType: string,
  eventHash: string,
  publicKey: string,
  signature: string
}

// == Serialization
external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
external parse_array:     string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// == Storage
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

// == Helpers
let hash = (str) => {
  let baEventHash = Sjcl.Sha256.hash(str)
  Sjcl.Hex.fromBits(baEventHash)
}

let sig = (hexSecretKey, hexStr) => {
  let secretKey = Sjcl.Ecdsa.SecretKey.fromHex(hexSecretKey)
  let baEventHash = Sjcl.Hex.toBits(hexStr)
  let baSig = Sjcl.Ecdsa.SecretKey.sign(secretKey, baEventHash)
  Sjcl.Hex.fromBits(baSig)
}

// == Election transactions
module SignedElection = {
  let make = (election : Election.t, owner : Identity.t) => {
    let event = Election.stringify(election)
    let eventHash = hash(event)
    {
      event,
      eventType: "election",
      eventHash,
      publicKey: owner.hexPublicKey,
      signature: sig(eventHash, Option.getExn(owner.hexSecretKey))
    }
  }

  let unwrap = (tx) : Election.t => {
    Election.parse(tx.event)
  }
}

// == Ballot transactions
module SignedBallot = {
  let make = (ballot : Ballot.t, owner : Identity.t) => {
    let event = Ballot.stringify(ballot)
    let eventHash = hash(event)
    {
      event,
      eventType: "ballot",
      eventHash,
      publicKey: owner.hexPublicKey,
      signature: sig(eventHash, Option.getExn(owner.hexSecretKey))
    }
  }

  let unwrap = (tx) : Ballot.t => {
    Ballot.parse(tx.event)
  }
}
