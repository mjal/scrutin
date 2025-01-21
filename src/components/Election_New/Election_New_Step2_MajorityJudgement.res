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

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Quelles sont les questions ?" -> React.string }
    </Title>

    <Election_New_ChoiceList answers=candidates setAnswers=setCandidates title="Quels sont les candidats" />

    <Election_New_Previous_Next next previous />
  </>
}
