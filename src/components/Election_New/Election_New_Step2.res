@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let {t} = ReactI18next.useTranslation()

  let question = "Question"
  let (answers, setAnswers) = React.useState(_ => ["", ""])

  let next = _ => {
    let question : QuestionH.t =  {
      question, answers, min: 1, max: 1
    }

    setState(_ => {
      ...state,
      step: Step3,
      questions: state.questions->Array.concat([question])
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { state.title->Option.getWithDefault("")->React.string }
      </Title>
    </View>

    <Election_New_ChoiceList answers setAnswers />

    <S.Button
      title={t(. "election.new.next")}
      disabled=(!Array.every(answers, (a) => a != ""))
      onPress=next
      />
  </>
}
