module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    <List.Item
      title=name
      left={_ => <List.Icon icon=Icon.name(selected ? "radiobox-marked" : "radiobox-blank") />}
      onPress={_ => onSelect()}
    />
  }
}

@react.component
let make = (~ballotTx) => {
  let (state, dispatch) = Context.use()
  let ballot = Map.String.getExn(state.cache.ballots, ballotTx)
  let election = Map.String.getExn(state.cache.elections, ballot.electionTx)
  let answers  = Belenios.Election.answers(Belenios.Election.parse(election.params))
  let nbAnswers = Array.length(answers)
  let (choice:option<int>, setChoice) = React.useState(_ => None)

  let vote = _ => {
    let selection =
      Array.make(nbAnswers, 0)
      -> Array.mapWithIndex((i, _e) => { choice == Some(i) ? 1 : 0 })

    let ballot = Ballot.make(ballot, election, selection)

    let owner = Array.getBy(state.ids, (id) => {
      Array.some(ballot.owners, (owner) => owner == id.hexPublicKey)
    }) -> Option.getExn

    let tx = Transaction.SignedBallot.make(ballot, owner)
    dispatch(Transaction_Add(tx))
  }

  <>
    <List.Section title="Choices">
    {
      Array.mapWithIndex(answers, (i, choiceName) => {
        let selected = choice == Some(i) 
        <Choice name=choiceName selected onSelect={_ => setChoice(_ => Some(i))} key=Int.toString(i) />
      }) -> React.array
    }
    </List.Section>
    <Button mode=#contained onPress=vote>{ "Voter" -> React.string }</Button>
  </>
}
