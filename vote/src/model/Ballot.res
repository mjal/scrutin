type signature_t = {
  hash: string,
  proof: Proof.serialized_t
}

type t = {
  election_uuid: string,
  election_hash: string,
  credential: string,
  answers: array<Answer.serialized_t>,
  signature: signature_t
}

@module("sirona") @scope("Ballot") @val
external generate : (Setup.t, string, array<array<int>>) => t = "generate"

external toJSON : t => Js.Json.t = "%identity"
