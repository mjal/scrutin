open ReactNative
open! Paper

type choice_t = Blank | Choice(int)

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
  let make = (~name, ~selected, ~onSelect) => {
    <List.Item
      title=name
      left={_ => <List.Icon icon=Icon.name(selected ? "checkbox-intermediate" : "checkbox-blank-outline") />}
      onPress={_ => onSelect()}
    />
  } 
}

@react.component
let make = (~currentChoice, ~onChoiceChange) => {
  let (state, _) = State.useContexts()

  <View>
    <List.Section title="Choices" style=styles["margin-x"]>
      {
        state.election.choices
        -> Array.mapWithIndex((i, choice) => {
          let selected = currentChoice == Choice(i)
          <Choice name=choice.name selected onSelect={_ => onChoiceChange(Choice(i))} key=Int.toString(i) />
        })
        -> React.array
      }
    </List.Section>
  </View>
}