type t = {
  id: int,
  email: string
}

let from_json = {
  open Json.Decode
  object(field => {
    id: field.required(. "id", int),
    email: field.required(. "email", string),
  })
}

let to_json = r => {
  open Json.Encode
  Unsafe.object({
    "id": int(r.id),
    "email": string(r.email)
  })
}
