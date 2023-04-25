module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item
      title=name
      style={Style.viewStyle(~padding=20.0->Style.dp, ~paddingLeft=40.0->Style.dp, ())}
      left={_ => <List.Icon icon={Icon.name(iconName)} />}
      onPress={_ => onSelect()}
    />
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()
  let (choice, setChoice) = React.useState(_ => None)
  let (_voteAgain, setVoteAgain) = React.useState(_ => false)

  let question = switch Election.description(election) {
  | "" => t(. "election.new.question")
  | question => question
  }

  <>
    <ElectionHeader election />

    { switch Array.getBy(state.accounts, (account) => {
      Array.getBy(election.voterIds, userId => userId == account.hexPublicKey)->Option.isSome
    }) {
    | None =>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
        {"Vous n'avez pas de clés de vote"->React.string}
      </Text>
    | Some(account) =>
      switch Array.getBy(state.ballots, (ballot) => {
        ballot.electionId == electionId && ballot.voterId == account.hexPublicKey
      }) {
      | None =>
        <>
          <View style=S.questionBox>
            <S.Section title=question />
            {Array.mapWithIndex(Election.choices(election), (i, choiceName) => {
              let selected = choice == Some(i)

              <Choice
                name=choiceName selected key={Int.toString(i)} onSelect={_ => setChoice(_ => Some(i))}
              />
            })->React.array}
          </View>
          <S.Button
            title="Voter"
            onPress={_ => {
              let nbChoices = Array.length(Election.choices(election))
              Core.Ballot.vote(~electionId, ~voter=account, ~choice, ~nbChoices)(state, dispatch)
              setVoteAgain(_ => false)
            }}
          />
        </>
      | Some(_ballot) =>
        <>
          <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
            {"Merci pour votre vote"->React.string}
          </Text>
          <S.Button
            title="Retour à l'élection"
            onPress={_ => { dispatch(Navigate(list{"elections", electionId})) }}
          />
          <S.Button
            title="Changer mon vote"
            onPress={_ => {
              setVoteAgain(_ => true)
            }}
          />
        </>
      }
    } }
  </>
}
