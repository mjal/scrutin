type step = Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  name: option<string>,
  choice: option<int>,
  priv: option<string>
}

let empty = { step: Step1, name: None, choice: None, priv: None }
