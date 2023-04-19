@react.component
let make = (~election:Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()

  React.useEffect(() => {
    if (Option.isSome(election.result)) {
      dispatch(Navigate(list{"elections", electionId, "result"}))
    }
    None
  })

  let ballots = 
    state.ballots
    -> Map.String.keep((_ballotId, ballot) =>
      ballot.electionId == electionId
    )
    -> Map.String.keep((_ballotId, ballot) =>
      state.ids
      -> Array.some((id) => {
        id.hexPublicKey == ballot.voterPublicKey
      })
    )

  let styles = {
    open Style
    StyleSheet.create({
      "choiceEditButton": viewStyle(
        ~position=#absolute,
        ~top=0.0->dp,
        ~right=0.0->dp,
        ~width=100.0->dp,
        ~backgroundColor=S.primaryColor,
        ()),
      "choiceListView": viewStyle(())
    })
  }

  <>
    <ElectionHeader election />

    <View>
      <ElectionShowChoices electionId />
      { switch Map.String.isEmpty(ballots) {
      | true => <></>
      | false =>
        <IconButton
          icon=Icon.name("square-edit-outline")
          style=styles["choiceEditButton"]
          onPress={_ => {
            let (ballotId, _ballot) =
              Option.getExn(Map.String.minimum(ballots))
            dispatch(Navigate(list{"ballots", ballotId}))
          }}
        />
      } }
    </View>

    //{ switch Map.String.isEmpty(ballots) {
    //| true => <></>
    //  //<S.Title>
    //  //  { "You are not invited to this election." -> React.string }
    //  //</S.Title>
    //| false => Map.String.mapWithKey(ballots, (ballotId, _ballot) => {
    //  // TODO: i18n
    //  <S.Button title="Use invite to vote" onPress={_ =>
    //    dispatch(Navigate(list{"ballots", ballotId}))
    //  } key=ballotId />
    //  }) -> Map.String.valuesToArray -> React.array
    //} }

    { switch State.getAccount(state, election.ownerPublicKey) {
    | Some(_adminAccount) =>
    <>
      <S.Button title="Ajouter des votants" onPress={_ => 
        dispatch(Navigate(list{"elections", electionId, "invite"}))
      } /> // TODO: i18n

      <S.Button title="Calculer le résultat" onPress={_ => // TODO: i18n
        Core.Election.tally(~electionId)(state, dispatch)
      } />
    </>
    | None => <></>
    } }
  </>
}
