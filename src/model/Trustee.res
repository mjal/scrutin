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
let fetch_all = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(Option.map(_, parse_array))
  ->Promise.thenResolve(Option.getWithDefault(_, []))
let store_all = trustees =>
  ReactNativeAsyncStorage.setItem(storageKey, stringify_array(trustees))->ignore
let clear = () => ReactNativeAsyncStorage.removeItem(storageKey)->ignore
