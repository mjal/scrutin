type access = [#"open" | #closed]
let accessToString = (access) => {
  switch access {
  | None => ""
  | Some(#"open") => "open"
  | Some(#"closed") => "closed"
  }
}
let stringToAccess = (str) => {
  switch str {
  | "open" => Some(#"open")
  | "closed" => Some(#"closed")
  | _ => None
  }
}

type step = Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  access: option<access>,
  emails: array<string>
}

let empty = {
  step: Step1,
  title: None,
  access: None,
  questions: [],
  emails: []
}
