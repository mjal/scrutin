type t = {
  id: int,
  email: string,
  privCred: string, // TODO: option<string>
}

let from_json = {
  open Json.Decode
  object(field => {
    id: field.required(. "id", int),
    email: field.required(. "email", string),
    privCred: field.required(. "priv_cred", string)
  })
}

let to_json = r => {
  open Json.Encode
  Unsafe.object({
    "id": int(r.id),
    "email": string(r.email),
    "priv_cred": string(r.privCred)
  })
}
