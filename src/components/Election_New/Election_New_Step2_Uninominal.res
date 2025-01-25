@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let { t } = ReactI18next.useTranslation()

  let (question, setQuestion) = React.useState(_ => "")
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

  let newQuestion = _ => {
    let question : QuestionH.t =  {
      question, answers, min: 1, max: 1
    }
    setQuestion(_ => "")
    setAnswers(_ => ["", ""])
    setState(_ => {
      ...state,
      step: Step2,
      questions: state.questions->Array.concat([question])
    })
  }

  let previous = _ => setState(_ => {...state, step: Step1})

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <S.Container>

      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.H1 text="Quelles sont les questions ?" />

      <S.Section title="Nom de la question (optionnel)" />

      <S.TextInput
        testID="election-question"
        value=question
        placeholder="Ma question"
        placeholderTextColor="#bbb"
        onChangeText={text => setQuestion(_ => text)}
      />

      <Election_New_ChoiceList answers setAnswers title={t(. "election.new.choiceList.choices")} />

    </S.Container>

    <Election_New_Previous_NewQuestion_Next next newQuestion previous />
  </>
}
