open ReactNative
open! Paper

let styles = {
  open Style
  StyleSheet.create({
    "margin-x": viewStyle(
      ~marginLeft=15.0->dp,
      ~marginRight=15.0->dp,
      ()
    )
  })
}

module Choice = {
  @react.component
  let make = (~choice: Choice.t) => {
  let (checked, setChecked) = React.useState(_ => false)

    <List.Item
      title=choice.name
      left={_ => <List.Icon icon=Icon.name(checked ? "checkbox-intermediate" : "checkbox-blank-outline") />}
      onPress={_ => setChecked(_ => checked ? false : true)}
    />
  } 
}

@react.component
let make = () => {
  let (state, _dispatch) = State.useContexts()

  <View>
    <List.Section title="Choices" style=styles["margin-x"]>
      {
        state.election.choices
        -> Array.mapWithIndex((i, choice) => <Choice choice key=Int.toString(i) />)
        -> React.array
      }
    </List.Section>
    <Button mode=#contained onPress={_ => ()}>
      {"Voter" -> React.string}
    </Button>
  </View>
}