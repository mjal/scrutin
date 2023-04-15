@react.component
let make = (~election:Election.t, ~electionId) => {
  let (state, dispatch) = Context.use()

  let ballots = 
    state.cachedBallots
    -> Map.String.keep((_ballotId, ballot) =>
      Array.some(state.ids, (id) => id.hexPublicKey == ballot.voterPublicKey)
    )

  <>
    <ElectionHeader election />

    <ElectionShowChoices electionId />

    { switch Map.String.isEmpty(ballots) {
    | true =>
      <Text>
        { "You are not invited to this election." -> React.string } // TODO: 18n
      </Text>
    | false => Map.String.mapWithKey(ballots, (ballotId, _ballot) => {
      // TODO: i18n
      <S.Button title="Use invite to vote" onPress={_ =>
        dispatch(Navigate(list{"ballot", ballotId}))
      } />
      }) -> Map.String.valuesToArray -> React.array
    } }


    { switch State.getAccount(state, election.ownerPublicKey) {
    | Some(_adminAccount) =>
    <>
      <S.Button title="Ajouter des votants" onPress={_ => ()} /> // TODO: i18n

      <S.Button title="Calculer le résultat" onPress={_ => // TODO: i18n
        Core.Election.tally(~electionId)(state, dispatch)
      } />
    </>
    | None => <></>
    } }
  </>
}
