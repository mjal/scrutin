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
  let (state, _) = Context.use()

  <View>
    <List.Section title="Choices" style=styles["margin-x"]>
      {
        Js.log(101)
        Js.log(state.election.params)
        Js.log(102)
        Js.log(state.election.params -> Option.getExn)
        Js.log(103)
        Js.log(state.election.params -> Option.getExn -> Belenios.Election.answers)
        state.election.params -> Option.getExn -> Belenios.Election.answers
        -> Array.mapWithIndex((i, choiceName) => {
          let selected = currentChoice == Choice(i)
          <Choice name=choiceName selected onSelect={_ => onChoiceChange(Choice(i))} key=Int.toString(i) />
        })
        -> React.array
      }
    </List.Section>
  </View>
}