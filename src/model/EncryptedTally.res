type t = {
  num_tallied: int,
  total_weight: int,
  encrypted_tally: array<array<ElGamal.t>>
}

type serialized_t = {
  num_tallied: int,
  total_weight: int,
  encrypted_tally: array<array<ElGamal.serialized_t>>
}

@module("sirona") @scope("EncryptedTally") @val
external generate : (Setup.t, array<Ballot.t>) => t = "generate"

@module("sirona") @scope("EncryptedTally") @val
external serialize: (t, Election.t) => serialized_t = "serialize"
