@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()

  switch Map.String.get(state.cachedElectionReplacementIds, electionId) {
  | Some(replacementId) =>
    <Text
      onPress={_ => dispatch(Navigate(list{"elections", replacementId}))}
      style=Style.textStyle(~color=Color.red,())>
    { "This object version is obselete.
      Click here for the next version"
      -> React.string
    }
    </Text>
  | None => <></>
  }
}
