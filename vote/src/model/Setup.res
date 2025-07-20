type t = {
  trustees: array<Trustee.t>,
  election: Election.t,
  credentials: array<string>
}

type serialized_t = {
  trustees: array<Trustee.serialized_t>,
  election: Election.serialized_t,
  credentials: array<string>
}

@module("sirona") @scope("Setup") @val
external parse: serialized_t => t = "parse"

@module("sirona") @scope("Setup") @val
external serialize: t => serialized_t = "serialize"
