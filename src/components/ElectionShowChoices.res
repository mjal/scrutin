@react.component
let make = (~election) => {
  let { t } = ReactI18next.useTranslation()

  let question = switch Election.description(election) {
  | "" => t(."election.new.question")
  | question => question
  }

  <View style=S.questionBox>
    <S.Section title=question />

    {
      Array.mapWithIndex(Election.choices(election), (i, name) => {
        <List.Item title=name key=Int.toString(i) />
      }) -> React.array
    }
  </View>
}
