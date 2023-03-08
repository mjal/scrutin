type t = {
  hexPublicKey:   string,
  hexSecretKey:   option<string>,
  email:          option<string>, // TODO: Remove
  phoneNumber:    option<string>,
}

let make = () => {
  let (
    publicKey: Sjcl.Ecdsa.PublicKey.t,
    secretKey: Sjcl.Ecdsa.SecretKey.t
  ) = Sjcl.Ecdsa.new()

  ({
    hexPublicKey:   Sjcl.Ecdsa.PublicKey.toHex(publicKey),
    hexSecretKey:   Some(Sjcl.Ecdsa.SecretKey.toHex(secretKey)),
    email:       None,
    phoneNumber: None,
  } : t)
}

let make2 = (~hexSecretKey) => {
  let secretKey = Sjcl.Ecdsa.SecretKey.fromHex(hexSecretKey)
  let publicKey = Sjcl.Ecdsa.SecretKey.toPub(secretKey)
  Js.log("publicKey")
  Js.log(publicKey)
  let hexPublicKey = Sjcl.Ecdsa.PublicKey.toHex(publicKey)
  let hexSecretKey = Some(hexSecretKey)
  ({
    hexPublicKey,
    hexSecretKey,
    email:       None,
    phoneNumber: None,
  } : t)
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
external parse_array:     string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

let storageKey = "identities"

let fetch_all = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  -> Promise.thenResolve(Js.Null.toOption)
  -> Promise.thenResolve(Option.map(_, parse_array))
  -> Promise.thenResolve(Option.getWithDefault(_, []))

let store_all = (ids) =>
  ReactNativeAsyncStorage.setItem(storageKey,
    stringify_array(ids)) -> ignore

let clear = () =>
  ReactNativeAsyncStorage.removeItem(storageKey) -> ignore
