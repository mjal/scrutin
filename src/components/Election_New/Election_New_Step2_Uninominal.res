@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let { t } = ReactI18next.useTranslation()

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step3,
    })
  }

  let newQuestion = _ => {
    let question : QuestionH.t = { question: "", answers: ["", ""], min: 1, max: 1 }
    let questions = Array.concat(state.questions, [question])
    setState(_ => {
      ...state,
      questions,
      step: Step2,
    })
  }

  let previous = _ => setState(_ => {...state, step: Step1})

  <>
    <Header title="Nouvelle élection" subtitle="2/5" />

    <S.Container>
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.H1 text="Quelles sont les questions ?" />

      { Array.mapWithIndex(state.questions, (i, question) => {
        let updateQuestion = name => {
          let question : QuestionH.t = {...question, question: name}
          let questions = Array.mapWithIndex(state.questions, (j, q) => {
            if i == j { question } else { q }
          })
          setState(_ => {...state, questions})
        }

        let answers = question.answers
        let updateAnswers = answers => {
          let question : QuestionH.t = {...question, answers}
          let questions = Array.mapWithIndex(state.questions, (j, q) => {
            if i == j { question } else { q }
          })
          setState(_ => {...state, questions})
        }

        <View style=Style.viewStyle(~borderWidth=3.0, ~marginVertical=10.0->Style.dp, ())>
          <S.Section title="Nom de la quetion (optionnel)" />

          <S.TextInput
            testID="election-question"
            value=question.question
            placeholder="Ma question"
            placeholderTextColor="#bbb"
            onChangeText=updateQuestion
          />

          <Election_New_ChoiceList answers updateAnswers
            title={t(. "election.new.choiceList.choices")} />
        </View>
      }) -> React.array }

      <S.Button
        title="Nouvelle question"
        onPress={_ => newQuestion()}
      />
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
