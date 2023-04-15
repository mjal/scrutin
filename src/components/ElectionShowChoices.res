open Style

@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let election = State.getElectionExn(state, electionId)

  let style = viewStyle(
    ~margin=30.0->dp,
    ~borderWidth=3.0,
    ~borderColor=S.primaryColor,
    ())

  let question = switch Election.description(election) {
  | "" => t(."election.new.question")
  | question => question
  }

  <View style>
    <S.Section title=question />

    {
      Array.mapWithIndex(Election.choices(election), (i, name) => {
        <List.Item title=name key=Int.toString(i) />
      }) -> React.array
    }
  </View>
}
