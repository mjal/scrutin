type signature_t = {
  hash: string,
  proof: Proof.serialized_t,
}

type t = {
  election_uuid: string,
  election_hash: string,
  credential: string,
  answers: array<Answer.serialized_t>,
  signature: signature_t,
}

@module("sirona") @scope("Ballot") @val
external generate: (Setup.t, string, array<array<int>>) => t = "generate"

@module("sirona") @scope("Ballot") @val
external b64hash: t => string = "b64hash"

external toJSON: t => Js.Json.t = "%identity"
