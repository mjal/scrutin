@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  let {t} = ReactI18next.useTranslation()

  let question = "Question"
  let (answers, setAnswers) = React.useState(_ => ["", ""])

  let next = _ => {
    let question : QuestionH.t =  {
      question, answers, min: 1, max: 1
    }

    dispatch(ElectionNewState.AddQuestion(question))
    dispatch(ElectionNewState.SetStep(Step4))
  }

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { state.title->Option.getWithDefault("")->React.string }
      </Title>
    </View>

    <ElectionNewChoiceList answers setAnswers />

    <S.Button
      title={t(. "election.new.next")}
      disabled=(!Array.every(answers, (a) => a != ""))
      onPress=next
      />
  </>
}
