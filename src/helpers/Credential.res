type t = {
  publicKey: Sjcl.Ecdsa.PublicKey.t,
  secretKey: Sjcl.Ecdsa.SecretKey.t,
}

let make = () => {
  let (publicKey, secretKey) = Sjcl.Ecdsa.new()
  {publicKey, secretKey}
}
