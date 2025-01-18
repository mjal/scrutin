type step = Step0 | Step0b | Step1 | Step2 | Step3 | Step4 | Step5
type time_t = {
  hours: int,
  minutes: int
}
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  access: option<Election.access>,
  emails: array<string>,
  votingMethod?: Election.votingMethod,
  startDate?: Js.Date.t,
  endDate?: Js.Date.t,
}

let empty = {
  step: Step0,
  title: None,
  access: None,
  questions: [],
  emails: []
}
