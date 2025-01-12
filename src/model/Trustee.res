module PublicKey = {
  type t = {
    pok: Proof.t,
    public_key: Point.t
  }
  type serialized_t = {
    pok: Proof.serialized_t,
    public_key: Point.serialized_t
  }
}

type t = (string, PublicKey.t)
type serialized_t = (string, PublicKey.serialized_t)

@module("sirona") @scope("Trustee") @val
external generate: () => (int, serialized_t) = "generate"

@module("sirona") @scope("Trustee") @val
external generateFromPriv: (BigInt.t) => (int, serialized_t) = "generateFromPriv"

@module("sirona") @scope("Trustee") @val
external fromJSON: (serialized_t) => t = "fromJSON"

@module("sirona") @scope("Trustee") @val
external toJSON: (t) => serialized_t = "toJSON"
