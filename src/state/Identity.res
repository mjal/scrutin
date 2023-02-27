type t = {
  hexPublicKey:   string,
  hexSecretKey:   option<string>,
  email:       option<string>,
  phoneNumber: option<string>,
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
