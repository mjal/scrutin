# Events

## election
{
  event: {
    type: "election",
    params,
    trustees,
    orgs: [org1.eventHash, org2.eventHash, ...],
  },
  eventHash: hash(event),
  orgSigs: [sig(orgSecretKey1, eventHash), sig(orgSecretKey2, eventHash), ...]
}

## ballot
{
  event: {
    type: "ballot",
    election: election.eventHash,
    ballot: {
      publicKey, // or token, but a publicKey can always be used instead of a hashed-token by sending the secretKey in place of the hash preimage (by mail, email, ...)
      ciphertext: ""
    }
  },
  eventHash: hash(event),
  orgSig: sig(orgSecretKey, eventHash)
}

## ballot.delete
TODO

## ballot.pubkey
{
  event: {
    type: "ballot.pubkey",
    previousBallot: ballot.eventHash,
    ballot: {
      publicKey,
      ciphertext # empty or unchanged
    }
  },
  eventHash: hash(event),
  orgSig: sig(orgSecretKey, eventHash)
}
// To update pubkey key when creating/recovering account
// /!\ Done by the organisation

## ballot.ciphertext
{
  event: {
    type: "ballot.ciphertext",
    previousBallot: ballot.eventHash,
    ballot: {
      publicKey, # unchanged
      ciphertext
    }
  },
  eventHash: hash(event),
  sig: sig(secretKey, eventHash)
}
// To vote
// /!\ Done by the user
// /!\ When aknowledged, could be locked (not allowing revotes) so that the voter has peace of mind /!\

## org
{
  event: {
    type: "org",
    orgPublicKey,
    ...
  }
  eventHash: hash(event),
  sig: sig(orgSecretKey, eventHash)
}

## member
{
  event: {
    type: "member",
    org: org.eventHash,
    member: {
      memberPublicKey
    }
  },
  eventHash: hash(event),
  sig: sig(orgSecretKey, eventHash)
}

## member.pubkey
TODO

## member.delete
TODO

# Auth server

POST /users
{
  email
}
=> Send an email with a token

POST /user/confirm
{
  pubkey
  email
  token
}

# Notes

// /!\ Org should maintain their own authentication database (associated for exemple with email or phone number)