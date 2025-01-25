@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  // let { t } = ReactI18next.useTranslation()

  let (candidates, setCandidates) = React.useState(_ => ["", ""])

  let questions = Array.map(candidates, candidate => {
    let question : QuestionH.t =  {
      question: candidate,
      answers: Election.grades,
      min: 1,
      max: 1
    }
    question
  })

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step3,
      questions
    })
  }

  let previous = _ => setState(_ => {...state, step: Step1})

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <S.Container>

      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.H1 text="Quelles sont les questions ?" />

      <Election_New_ChoiceList answers=candidates setAnswers=setCandidates title="Quels sont les candidats" />

    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
