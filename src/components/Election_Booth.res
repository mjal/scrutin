@react.component
let make = (~election: Election.t) => {
  //let (state, dispatch) = Context.use()
  //let (showModal, setshowModal) = React.useState(_ => false)
  //let (visibleError, setVisibleError) = React.useState(_ => false)
  //let (hasVoted, setHasVoted) = React.useState(_ => false)
  //let (changeVote, setChangeVote) = React.useState(_ => false)

  //let election = Map.String.getExn(state.cache.elections, eventHash)
  let answers  = Belenios.Election.answers(Belenios.Election.parse(election.params))
  let (votingInProgress, setVotingInProgress) = React.useState(_ => false)
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
        //<ElectionBooth_ChoiceSelect election choice setChoice />
      </>
    } }
  } }
}