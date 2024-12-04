@react.component
let make = (~election: Sirona.Election.t) => {
  let {t} = ReactI18next.useTranslation()

  let question = switch election.name {
  | "" => t(. "election.new.question")
  | question => question
  }

  {Array.mapWithIndex(election.questions, (j, question) => {
    <View style=S.questionBox key={Int.toString(j)}>
      <S.Section title=question.question />
      {Array.mapWithIndex(question.answers, (i, name) => {
        <List.Item title=name key={`${Int.toString(j)}-${Int.toString(i)}`} />
      })->React.array}
    </View>
  })->React.array}
}
