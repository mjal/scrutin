type t = {
  choiceId: option<int>,
  token: string,
}

let initial = {
  choiceId: None,
  token: "",
}

let from_json = {
  open Json.Decode
  object(field => {
    choiceId: field.optional(. "choice_id", int),
    token: field.required(. "hashed_token", string),
  })
  //json->Json.decode(decode=object)->Result.getExn
}

let to_json = (r: t) : Js.Json.t => {
  open! Json.Encode
  Unsafe.object({
    "choice_id": r.choiceId,
    "token": string(r.token),
  })
}
