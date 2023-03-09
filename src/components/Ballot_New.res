module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item title=name
      left={_ => <List.Icon icon=Icon.name(iconName) />}
      onPress={_ => onSelect()}
    />
  }
}

@react.component
let make = (~ballotTx) => {
  let (state, dispatch) = Context.use()
  let ballot = Map.String.getExn(state.cached_ballots, ballotTx)
  let election = Map.String.getExn(state.cached_elections, ballot.electionTx)
  let answers  = Belenios.Election.answers(Belenios.Election.parse(election.params))
  let nbChoices = Array.length(answers)
  let (choice, setChoice) = React.useState(_ => None)

  <>
    <List.Section title="Choices">
    {
      Array.mapWithIndex(answers, (i, choiceName) => {
        let selected = choice == Some(i) 

        <Choice name=choiceName selected key=Int.toString(i)
          onSelect={_ => setChoice(_ => Some(i))} />
      }) -> React.array
    }
    </List.Section>

    <Button mode=#contained onPress={_ => {
      Core.Ballot.vote(~ballot, ~choice, ~nbChoices)(state, dispatch)
    }}>{ "Voter" -> React.string }</Button>
  </>
}
