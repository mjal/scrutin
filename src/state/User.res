type t = {
  id: int,
  email: string,
  publicKey: string,
  secretKey: option<string>
}

let to_json = r => {
  open Json.Encode
  Unsafe.object({
    "email": string(r.email),
    "publicKey": string(r.publicKey)
  })
}
