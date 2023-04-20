@react.component
let make = () => {
  let (state, _) = StateContext.use()

  let text = switch state.fetchingEvents {
  | true => "Please wait. Loading in progress..."
  | false => "Object is not found."
  }

  <Text style=S.flatten([S.title,Style.textStyle(~marginTop=50.0->Style.dp,())])>
    { text->React.string }
  </Text>
}
