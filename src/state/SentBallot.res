type t = {
  electionId: int,
  choiceId: int,
  token: string,
}

let initial = {
  electionId: 0,
  choiceId: 0,
  token: "",
}

let to_json = (r: t) : Js.Json.t => {
  open! Json.Encode
  Unsafe.object({
    "election_id": r.electionId,
    "choice_id": r.choiceId,
    "token": r.token
  })
}
