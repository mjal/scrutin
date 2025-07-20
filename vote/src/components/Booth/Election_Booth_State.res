type step = Step1 | Step2 | Step3 | Step4
type t = {
  step: step,
  name: option<string>,
  choices: option<array<option<int>>>,
  priv: option<string>
}

let empty = { step: Step1, name: None, choices: None, priv: None }
