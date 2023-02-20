type t = {
  electionUuid: option<string>,
  ciphertext: option<string>,
  privateCredential: string,
  publicCredential: string
}

let initial = {
  electionUuid: None,
  ciphertext: None,
  privateCredential: "",
  publicCredential: ""
}

let from_json = {
  open Json.Decode
  object(field => {
    {
      electionUuid: field.optional(. "election_uuid", string),
      ciphertext: field.required(. "ciphertext", option(string)),
      publicCredential: field.required(. "public_credential", string),
      privateCredential: Option.getWithDefault(field.optional(. "private_credential", string), "")
    }
  })
}

let to_json = (r: t) : Js.Json.t => {
  open! Json.Encode
  Unsafe.object({
    "election_uuid": option(string, r.electionUuid),
    "ciphertext": option(string, r.ciphertext),
    "public_credential": string(r.publicCredential),
    "private_credential": string(r.privateCredential)
  })
}
