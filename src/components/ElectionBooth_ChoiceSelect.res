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
let make = (~election: Election.t, ~choice, ~setChoice, ~disabled=false) => {
  let (state, _) = Context.use()
  let answers = Belenios.Election.answers(Belenios.Election.parse(election.params))

  <View>
    <List.Section title={disabled?"Liste des choix":"Faites votre choix"} style=styles["margin-x"]>
      {
        Array.mapWithIndex(answers, (i, choiceName) => {
          if disabled {
            <List.Item title=choiceName />
          } else {
            let selected = choice == Some(i) 
            <Choice name=choiceName selected onSelect={_ => setChoice(Some(i))} key=Int.toString(i) />
          }
        }) -> React.array
      }
    </List.Section>
  </View>
}