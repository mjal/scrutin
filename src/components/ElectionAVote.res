@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let (_state, dispatch) = StateContext.use()
  let _ = election
  <>
    <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
      {"Merci pour votre vote"->React.string}
    </Text>
    <S.Button
      title="Retour à l'élection"
      onPress={_ => { dispatch(Navigate(list{"elections", electionId})) }}
    />
  </>
}
