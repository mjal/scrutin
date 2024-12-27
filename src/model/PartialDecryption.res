type payload_t = {
  decryption_factors: array<array<Point.serialized_t>>,
  decryption_proofs: array<array<Proof.serialized_t>>
}

type t = {
  owner: int,
  payload: payload_t
};

@module("sirona") @scope("PartialDecryption") @val
external generate : (Setup.t, EncryptedTally.t, int, int /*bigint*/) => t = "generate"
