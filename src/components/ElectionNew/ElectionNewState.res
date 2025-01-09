type step = Step1 | Step2 | Step3 | Step4 | Step5
type t = {
  step: step,
  title: option<string>,
  questions: array<QuestionH.t>,
  emails: array<string>
}

type action =
  | Reset
  | SetStep(step)
  | SetTitle(string)
  | AddQuestion(QuestionH.t)

let empty = { step: Step1, title: None, questions: [], emails: [] }

let reducer = (state, action) => {
  switch action {
  | Reset => empty
  | SetStep(step) => {...state, step }
  | SetTitle(title) => {...state, title: Some(title) }
  | AddQuestion(question) => {...state, questions: Array.concat(state.questions, [question]) }
  }
}

