type step = Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  name: option<string>,
  choice: option<int>,
}

type action =
  | Reset
  | SetStep(step)
  | SetChoice(option<int>)
  | SetName(string)

let empty = { step: Step1, name: None, choice: None }

let reducer = (state, action) => {
  switch action {
  | Reset => empty
  | SetStep(step) => {...state, step }
  | SetName(name) => {...state, name: Some(name) }
  | SetChoice(choice) => {...state, choice }
  }
}
