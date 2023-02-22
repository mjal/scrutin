module Election =
{
  let create = (params, trustees, orgPublicKey) => {
    {
      "type": "election",
      "params": params,
      "trustees": trustees,
      "orgPublicKey": Sjcl.Ecdsa.PublicKey.toHex(orgPublicKey)
    }
  }
}

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
    let { event, eventHash, sig } = signedEvent
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