@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  // let { t } = ReactI18next.useTranslation()

  let candidates = Array.map(state.questions, (question) => question.question)

  let updateAnswers = candidates => {
    let questions = Array.map(candidates, candidate => {
      let question : QuestionH.t =  {
        question: candidate,
        answers: Election.grades,
        min: 1,
        max: 1
      }
      question
    })
    setState(_ => {...state, questions})
  }

  let next = _ => setState(_ => { ...state, step: Step3, })
  let previous = _ => setState(_ => {...state, step: Step1})

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <S.Container>

      <Election_New_ChoiceList answers=candidates updateAnswers
        title="Quelles sont les options" />

    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
