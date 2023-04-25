type t = {
  userId: string,
  secret: string,
}

let make = () => {
  let (publicKey: Sjcl.Ecdsa.PublicKey.t, secretKey: Sjcl.Ecdsa.SecretKey.t) = Sjcl.Ecdsa.new()

  (
    {
      userId: Sjcl.Ecdsa.PublicKey.toHex(publicKey),
      secret: Sjcl.Ecdsa.SecretKey.toHex(secretKey),
    }: t
  )
}

let make2 = (~secret) => {
  let sec = Sjcl.Bn.fromBits(Sjcl.Hex.toBits(secret))
  let keys = Sjcl.Ecdsa.generateKeysFromSecretKey(sec)
  let userId = Sjcl.Ecdsa.PublicKey.toHex(keys.pub)

  {
    userId,
    secret,
  }
}

// #### methods

let signHex = (account, hexStr) => {
  let secretKey = Sjcl.Ecdsa.SecretKey.fromHex(account.secret)
  let baEventHash = Sjcl.Hex.toBits(hexStr)
  let baSig = Sjcl.Ecdsa.SecretKey.sign(secretKey, baEventHash)
  Sjcl.Hex.fromBits(baSig)
}

// #### Serialization

external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"
external parse_array: string => array<t> = "JSON.parse"
external stringify_array: array<t> => string = "JSON.stringify"

// #### Storage

let storageKey = "accounts"

let loadAll = () =>
  ReactNativeAsyncStorage.getItem(storageKey)
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(Option.map(_, parse_array))
  ->Promise.thenResolve(Option.getWithDefault(_, []))

let store_all = accounts => ReactNativeAsyncStorage.setItem(storageKey, stringify_array(accounts))->ignore

let clear = () => ReactNativeAsyncStorage.removeItem(storageKey)->ignore
