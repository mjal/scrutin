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

/*
module Ballot =
{
  let create = (electionHash, userPublicKey, orgPublicKey) => {
    {
      "type": "election.ballot",
      "electionHash": electionHash,
      "userPublicKey": Sjcl.Ecdsa.PublicKey.toHex(userPublicKey),
      "orgPublicKey": Sjcl.Ecdsa.PublicKey.toHex(orgPublicKey),
    }
  }

  let setCiphertext = (ballotHash, ciphertext) => {
    {
      "type": "election.ballot.ciphertext",
      "ballotHash": ballotHash,
      "ciphertext": ciphertext
    }
  }

  let updateUserPublicKey = (ballotHash, userPublicKey) => {
    {
      "type": "election.ballot.userPublicKey",
      "ballotHash": ballotHash,
      "userPublicKey": userPublicKey
    }
  }

  let delete = (ballotHash) => {
    {
      "type": "election.ballot.delete",
      "ballotHash": ballotHash
    }
  }
}

module Signed =
{
  type t = {
    event: string,
    eventHash: string,
    sig: string
  }

  let wrap = (content, secretKey) => {
    let sEvent = Belt.Option.getExn(Js.Json.stringifyAny(content))
    let baEventHash = Sjcl.Sha256.hash(sEvent)
    let eventHash = Sjcl.Hex.fromBits(baEventHash)
    let sig =
      baEventHash
      -> Sjcl.Ecdsa.SecretKey.sign(secretKey, _)
      -> Sjcl.Hex.fromBits

    {
      event: sEvent,
      eventHash,
      sig
    }
  }

  module Election =
  {
    let create = (params, trustees, org : Credential.t) => {
      Election.create(params, trustees, org.publicKey)
      -> wrap(org.secretKey)
    }
  }

  module Ballot =
  {
    let create = (electionHash, userPublicKey, org : Credential.t) => {
      Ballot.create(electionHash, userPublicKey, org.publicKey)
      -> wrap(org.secretKey)
    }

    let setCiphertext = (ballotHash, ciphertext, user : Credential.t) => {
      Ballot.setCiphertext(ballotHash, ciphertext)
      -> wrap(user.secretKey)
    }

    let updateUserPublicKey = (ballotHash, userPublicKey, org : Credential.t) => {
      Ballot.updateUserPublicKey(ballotHash, userPublicKey)
      -> wrap(org.secretKey)
    }

    let delete = (ballotHash, org : Credential.t) => {
      Ballot.delete(ballotHash)
      -> wrap(org.secretKey)
    }

  let verifySig = ({ event, eventHash, sig } : t, publicKey) => {
    let baEventHash = Sjcl.Sha256.hash(event)
    let eventHash2 = Sjcl.Hex.fromBits(baEventHash)
    if eventHash != eventHash2 { false } else {
      Sjcl.Ecdsa.PublicKey.verify(publicKey, ~hash=Sjcl.Hex.toBits(eventHash), ~signature=Sjcl.Hex.toBits(sig))
    }
  }

  exception EventVerifyFailed(string)

  let jsonGet = (json, propName) =>
    //json
    //-> Belt.Option.flatMap(Js.Json.decodeObject)
    Js.Json.decodeObject(json)
    -> Belt.Option.flatMap(Js.Dict.get(_, propName))
    -> Belt.Option.flatMap(Js.Json.decodeString)

  let findByHash = (signedEvents : array<t>, hash) => {
    Belt.Array.getBy(signedEvents, (e) => e.eventHash == hash)
    -> Belt.Option.map((e) => e.event)
    -> Belt.Option.map(Js.Json.parseExn)
  }

  let verify = (signedEvents : array<t>, signedEvent) => {
    let event = signedEvent.event
    let json = Js.Json.parseExn(event)
    let publicKey = 
    switch jsonGet(json, "type") {
    | Some("election") =>
      jsonGet(json, "orgPublicKey")
      -> Belt.Option.map(Sjcl.Ecdsa.PublicKey.fromHex)
    | Some("election.ballot") =>
      let election = jsonGet(json, "electionHash")
      -> Belt.Option.flatMap((hash) => findByHash(signedEvents, hash))
      election
      -> Belt.Option.flatMap((event) => jsonGet(event, "orgPublicKey"))
      -> Belt.Option.map(Sjcl.Ecdsa.PublicKey.fromHex)
      // TODO: Verify that orgPublicKey is the same in the election and in the ballot
    | Some("election.ballot.ciphertext") =>
      let election = jsonGet(json, "ballotHash")
      -> Belt.Option.flatMap((hash) => findByHash(signedEvents, hash))
      election
      -> Belt.Option.flatMap((event) => jsonGet(event, "userPublicKey"))
      -> Belt.Option.map(Sjcl.Ecdsa.PublicKey.fromHex)
    | Some("election.ballot.userPublicKey") => {
      let election = jsonGet(json, "ballotHash")
      -> Belt.Option.flatMap((hash) => findByHash(signedEvents, hash))
      election
      -> Belt.Option.flatMap((event) => jsonGet(event, "orgPublicKey"))
      -> Belt.Option.map(Sjcl.Ecdsa.PublicKey.fromHex)
    }
    | None => raise(EventVerifyFailed("No type"))
    | _    => raise(EventVerifyFailed("Unknown type"))
    }
    switch publicKey {
    | None => false
    | Some(publicKey) => verifySig(signedEvent, publicKey)
    }
    }
  }
}
*/
