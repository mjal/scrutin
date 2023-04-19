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
      <ElectionShowChoices election />
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
    <View style=Style.viewStyle( ~marginTop=-30.0->Style.dp, ())>
      <View style=Style.viewStyle(
        ~position=#absolute,
        ~right=30.0->Style.dp,
        ())>
      <Text style=Style.textStyle(
        ~width=80.0->Style.dp,
        ~backgroundColor=S.primaryColor,
        ~color=Color.white,
        ~paddingBottom=5.0->Style.dp,
        ~paddingLeft=8.0->Style.dp,
        ())>
        { "Vote privé" -> React.string }
      </Text>
      </View>
    </View>

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
