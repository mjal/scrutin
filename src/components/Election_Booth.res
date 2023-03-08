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
  let (choice:option<int>, setChoice) = React.useState(_ => None)

  let vote = _ => {
    let ballot : Ballot.t = {
      electionTx: ballot.electionTx,
      previousTx: Some(ballotTx),
      ciphertext: None,
      owners: []
    }

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

/*
  let _answers  = Belenios.Election.answers(Belenios.Election.parse(election.params))
  let (votingInProgress, _setVotingInProgress) = React.useState(_ => false)
  let (choice:option<int>, setChoice) = React.useState(_ => None)
  //let choice = Some(1)

  { if votingInProgress {
    <Title style=X.styles["title"]>
      <Text>{"Vote en cours..." -> React.string}</Text>
      <ActivityIndicator />
    </Title>
  } else {
    {if (false) {
      <>
        <Title style=StyleSheet.flatten([X.styles["title"],X.styles["green"]])>
          { "Vous avez voté" -> React.string }
        </Title>
        //<Button mode=#contained onPress={_ => setChangeVote(_ => true)}>
        //  {"Changer mon vote" -> React.string}
        //</Button>
      </>
    } else {
      <>
        <Election_Booth_ChoiceList election choice setChoice />
        <Button>{ "Voter" -> React.string }</Button>
      </>
    } }
  } }
*/
}
