@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let _ = electionId
  //let (state, _dispatch) = StateContext.use()
  //let { t } = ReactI18next.useTranslation()

  Js.log("got")
  Js.log(election)

  //let nbVotes = state
  //  ->State.getElectionValidBallots(electionId)
  //  ->Array.length

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

    //{switch election.result {
    //| Some(_) =>
    //  <S.Button
    //    title="Afficher le résultat"
    //    onPress={_ => dispatch(Navigate(list{"elections", electionId, "result"}))}
    //  />
    //| None =>
    //  switch state->State.getElectionAdmin(election) {
    //  | None => <> </>
    //  | Some(_adminAccount) =>
    //    <>
    //      <S.Button
    //        title="Ajouter des votants"
    //        testID="button-invite"
    //        onPress={_ => dispatch(Navigate(list{"elections", electionId, "invite"}))}
    //      />
    //      <S.Title>{`${nbVotes->Int.toString} votes yet` -> React.string}</S.Title>
    //      <S.Button
    //        title=t(. "election.show.closeAndTally")
    //        onPress={_ => Core.Election.tally(~electionId)(state, dispatch)}
    //      />
    //    </>
    //  }
    //}}
  </>
}
