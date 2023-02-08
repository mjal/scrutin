type t = {
  id: option<int>,
  email: string,
  password: string
}

let to_json = r => {
  open Json.Encode
  Unsafe.object({
    "email": string(r.email),
    "password": string(r.password)
  })
}