@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()

  let nbVotes = state
    ->State.getElectionValidBallots(electionId)
    ->Array.length

  <>
    <ElectionHeader election />
    <View>
      <ElectionShowChoices election />
    </View>
    <View style={Style.viewStyle(~marginTop=-30.0->Style.dp, ())}>
      <View style={Style.viewStyle(~position=#absolute, ~right=30.0->Style.dp, ())}>
        <Text
          style={Style.textStyle(
            ~width=switch ReactNative.Platform.os {
            | #web => 80.0->Style.dp
            | _ => 120.0->Style.dp
            },
            ~backgroundColor=S.primaryColor,
            ~color=Color.white,
            ~paddingBottom=5.0->Style.dp,
            ~paddingLeft=8.0->Style.dp,
            (),
          )}>
          {"Vote privé"->React.string}
        </Text>
      </View>
    </View>

    { switch ReactNative.Platform.os {
    | #web => <></>
    | _ => <View style={Style.viewStyle(~height=30.0->Style.dp, ())} />
    } }

    {switch election.result {
    | Some(_) =>
      <S.Button
        title="Afficher le résultat"
        onPress={_ => dispatch(Navigate(list{"elections", electionId, "result"}))}
      />
    | None =>
      switch state->State.getElectionAdmin(election) {
      | None => <> </>
      | Some(_adminAccount) =>
        <>
          <S.Button
            title="Ajouter des votants"
            testID="button-invite"
            onPress={_ => dispatch(Navigate(list{"elections", electionId, "invite"}))}
          />
          <S.Button
            title={`Calculer le résultat des ${nbVotes->Int.toString} votes`}
            onPress={_ => Core.Election.tally(~electionId)(state, dispatch)}
          />
        </>
      }
    }}
  </>
}
