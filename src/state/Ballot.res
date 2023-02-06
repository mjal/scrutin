type t = {
  electionId: int,
  ciphertext: option<string>,
  private_credential: string,
  public_credential: string
}

let initial = {
  electionId: 0,
  ciphertext: None,
  private_credential: "",
  public_credential: ""
}

let from_json = {
  open Json.Decode
  object(field => {
    let electionId = field.optional(. "election_id", int)
    {
      electionId: Option.getWithDefault(electionId, 0),
      ciphertext: field.required(. "ciphertext", option(string)),
      public_credential: field.required(. "public_credential", string),
      private_credential: Option.getWithDefault(field.optional(. "private_credential", string), "")
    }
  })
}

let to_json = (r: t) : Js.Json.t => {
  open! Json.Encode
  Unsafe.object({
    "election_id": r.electionId,
    "ciphertext": option(string, r.ciphertext),
    "public_credential": string(r.public_credential),
    "private_credential": string(r.private_credential)
  })
}
