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
let make = (~currentChoice, ~onChoiceChange, ~disabled=false) => {
  let (state, _) = Context.use()

  <View>
    <List.Section title={disabled?"Liste des choix":"Faites votre choix"} style=styles["margin-x"]>
      {
        switch state.election.params {
        | None => <></>
        | Some(params) =>
          Belenios.Election.answers(params)
          -> Array.mapWithIndex((i, choiceName) => {
            let selected = currentChoice == Choice(i)
            if disabled {
              <List.Item title=choiceName />
            } else {
              <Choice name=choiceName selected onSelect={_ => onChoiceChange(Choice(i))} key=Int.toString(i) />
            }
          })
          -> React.array
        }
      }
    </List.Section>
  </View>
}