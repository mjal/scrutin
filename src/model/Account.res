type t = {
  hexPublicKey:   string,
  hexSecretKey:   option<string>,
}

let make = () => {
  let (
    publicKey: Sjcl.Ecdsa.PublicKey.t,
    secretKey: Sjcl.Ecdsa.SecretKey.t
  ) = Sjcl.Ecdsa.new()

  ({
    hexPublicKey:   Sjcl.Ecdsa.PublicKey.toHex(publicKey),
    hexSecretKey:   Some(Sjcl.Ecdsa.SecretKey.toHex(secretKey)),
  } : t)
}

let make2 = (~hexSecretKey) => {
  let sec = Sjcl.Bn.fromBits(Sjcl.Hex.toBits(hexSecretKey))
  let keys = Sjcl.Ecdsa.generateKeysFromSecretKey(sec)
  let hexPublicKey = Sjcl.Ecdsa.PublicKey.toHex(keys.pub)

  {
    hexPublicKey,
    hexSecretKey: Some(hexSecretKey),
  }
}

// #### methods

let signHex = (id, hexStr) => {
  let hexSecretKey = Option.getExn(id.hexSecretKey)
  let secretKey = Sjcl.Ecdsa.SecretKey.fromHex(hexSecretKey)
  let baEventHash = Sjcl.Hex.toBits(hexStr)
  let baSig = Sjcl.Ecdsa.SecretKey.sign(secretKey, baEventHash)
  Sjcl.Hex.fromBits(baSig)
}

// #### Serialization

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
external parse_array:     string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// #### Storage

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

