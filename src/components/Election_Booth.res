@react.component
let make = (~ballotTx) => {
  let (state, _dispatch) = Context.use()
  let ballot = Map.String.getExn(state.cache.ballots, ballotTx)
  let election = Map.String.getExn(state.cache.elections, ballot.electionTx)

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
}
