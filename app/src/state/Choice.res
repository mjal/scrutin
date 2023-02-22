type t = {
  id: int,
  name: string
}

let from_json = {
  open Json.Decode
  object(field => {
    id: field.required(. "id", int),
    name: field.required(. "name", string),
  })
}

let to_json = r => {
  open Json.Encode
  Unsafe.object({
    "id": int(r.id),
    "name": string(r.name)
  })
}
