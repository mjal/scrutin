type step = Step0 | Step0b | Step0c | Step1 | Step2 | Step3 | Step4 | Step_Password | Step_Password_Disclaimer | Step6
type passwordPolicy = [ #local | #file | #extern ]
type time_t = { hours: int, minutes: int }

type t = {
  step: step,
  title: string,
  desc: string,
  questions: array<QuestionH.t>,
  emails: array<string>,
  access?: Election.access,
  votingMethod?: Election.votingMethod,
  startDate?: Js.Date.t,
  endDate?: Js.Date.t,
  passwordPolicy?: passwordPolicy,
  mnemonic?: string,
  election?: Election.t,
  trustees?: array<Trustee.t>
}

let empty = {
  step: Step0,
  title: "",
  desc: "",
  questions: [],
  emails: [],
  votingMethod: #uninominal,
}
