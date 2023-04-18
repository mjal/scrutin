open Style

@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()
  let { t } = ReactI18next.useTranslation()
  // TODO: Get from params instead of refetchin?
  let election = State.getElectionExn(state, electionId)

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
