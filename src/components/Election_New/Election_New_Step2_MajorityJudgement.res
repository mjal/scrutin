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

    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { state.title->Option.getWithDefault("")->React.string }
      </Title>
    </View>

    <Election_New_ChoiceList answers=candidates setAnswers=setCandidates title="Quels sont les candidats" />

    <Election_New_Previous_Next next previous />
  </>
}
