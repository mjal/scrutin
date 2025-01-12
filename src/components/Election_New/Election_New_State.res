// TODO: Replace reducer by a simple useState

type access = [#"open" | #closed]
type step = Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  access: option<access>,
  emails: array<string>
}

type action =
  | Reset
  | SetStep(step)
  | SetTitle(string)
  | SetAccess(access)
  | AddQuestion(QuestionH.t)

let empty = {
  step: Step1,
  title: None,
  access: None,
  questions: [],
  emails: []
}

let reducer = (state, action) => {
  switch action {
  | Reset => empty
  | SetStep(step) => {...state, step }
  | SetTitle(title) => {...state, title: Some(title) }
  | SetAccess(access) => {...state, access: Some(access) }
  | AddQuestion(question) => {...state, questions: Array.concat(state.questions, [question]) }
  }
}

