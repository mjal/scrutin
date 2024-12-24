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
external create: () => (int, serialized_t) = "generate"

@module("sirona") @scope("Trustee") @val
external fromJSON: (serialized_t) => t = "fromJSON"

@module("sirona") @scope("Trustee") @val
external toJSON: (t) => serialized_t = "toJSON"

/*
type t = {
  trustees: Belenios.Trustees.t,
  privkey: Belenios.Trustees.Privkey.t,
}

let make = () => {
  let (privkey, trustees) = Belenios.Trustees.create()
  {trustees, privkey}
}

// == Serialization
external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"
external parse_array: string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// == Storage
let storageKey = "trustees"
let loadAll = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(Option.map(_, parse_array))
  ->Promise.thenResolve(Option.getWithDefault(_, []))
let store_all = trustees =>
  ReactNativeAsyncStorage.setItem(storageKey, stringify_array(trustees))->ignore
let clear = () => ReactNativeAsyncStorage.removeItem(storageKey)->ignore
*/
