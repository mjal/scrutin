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
  let (choice, setChoice) = React.useState(_ => None)

  let ballot = state -> State.getBallot(ballotTx)
  let election = state -> State.getElection(ballot.electionTx)

  let owner = Array.getBy(state.ids, (id) => {
    ballot.voterPublicKey == id.hexPublicKey
  })

  switch owner {
  | Some(_owner) =>
    <>
      <List.Section title="Choices">
      {
        Array.mapWithIndex(Election.choices(election), (i, choiceName) => {
          let selected = choice == Some(i) 

          <Choice name=choiceName selected key=Int.toString(i)
            onSelect={_ => setChoice(_ => Some(i))} />
        }) -> React.array
      }
      </List.Section>

      <Button mode=#contained onPress={_ => {
        let nbChoices = Array.length(Election.choices(election))
        Core.Ballot.vote(~ballot, ~choice, ~nbChoices)(state, dispatch)
      }}>{ "Voter" -> React.string }</Button>
    </>
  | None =>
    <Title style=X.styles["title"]>
      { "You don't have voting right" -> React.string }
    </Title>
  }
}
