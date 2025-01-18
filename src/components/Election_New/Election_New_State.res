type access = [#"open" | #closed]
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
let votingMethodToString = (access) => {
  switch access {
  | #uninominal => "uninominal"
  | #majorityJudgement => "majorityJudgement"
  }
}
let stringToVotingMethod = (str) => {
  switch str {
  | "majorityJudgement" => #majorityJudgement
  | _ => #uninominal
  }
}

type step = Step0 | Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  access: option<access>,
  emails: array<string>,
  votingMethod?: votingMethod
}

let empty = {
  step: Step0,
  title: None,
  access: None,
  questions: [],
  emails: []
}
