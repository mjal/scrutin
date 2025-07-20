type access = [#"open" | #closed]
// TODO: Move to component
let accessToString = (access) => {
  switch access {
  | None => ""
  | Some(#"open") => "open"
  | Some(#closed) => "closed"
  }
}
let stringToAccess = (str) => {
  switch str {
  | "open" => Some(#"open")
  | "closed" => Some(#closed)
  | _ => None
  }
}

type votingMethod = [#uninominal | #majorityJudgement]
// TODO: Move to component
let votingMethodToString = (votingMethod) => {
  switch votingMethod {
  | None => ""
  | Some(#uninominal) => "uninominal"
  | Some(#majorityJudgement) => "majorityJudgement"
  }
}
let stringToVotingMethod = (str) => {
  switch str {
  | "majorityJudgement" => Some(#majorityJudgement)
  | "uninominal" => Some(#uninominal)
  | _ => None
  }
}

let grades = [
  "Très bien",
  "Bien",
  "Neutre",
  "Mauvais",
  "Très mauvais",
]

type t = {
  version: int,
  description: string,
  name: string,
  group: string,
  public_key: Point.t,
  questions: array<QuestionH.t>,
  uuid: string,
  administrator?: string,
  credential_authority?: string,
  access?: access,
  votingMethod?: votingMethod,
  startDate?: Js.Date.t,
  endDate?: Js.Date.t
}
type serialized_t

@module("sirona") @scope("Election") @val
external create: (string, string, array<Trustee.t>, array<QuestionH.t>) => t = "create"

external toJSON : t => Js.Json.t = "%identity"
external toJSONs : serialized_t => Js.Json.t = "%identity"

external fromJSON : string => t = "JSON.parse"
external fromJSONs : string => serialized_t = "JSON.parse"

@module("sirona") @scope("Election") @val
external parse: serialized_t => t = "parse"

@module("sirona") @scope("Election") @val
external serialize: t => serialized_t = "serialize"
