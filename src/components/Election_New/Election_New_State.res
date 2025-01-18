type step = Step0 | Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  access: option<Election.access>,
  emails: array<string>,
  votingMethod?: Election.votingMethod
}

let empty = {
  step: Step0,
  title: None,
  access: None,
  questions: [],
  emails: []
}
