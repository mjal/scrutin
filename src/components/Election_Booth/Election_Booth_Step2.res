@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = (electionData, state)
  let (name, setName) = React.useState(_ => Option.getWithDefault(state.name, ""))

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step3,
      name: Some(name),
    })
  }

  let previous = _ => setState(_ => { ...state, step: Step1 })

  <>
    <Header title="S'identifier" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />
  
    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Qui êtes-vous ?" -> React.string }
    </Title>
  
    <S.TextInput placeholder="Votre nom"
      autoFocus=true
      value=name
      onChangeText={text => setName(_ => text)}
      onSubmitEditing=next
    />

    {
      let style = Style.viewStyle(
        ~flexDirection=#row,
        ~justifyContent=#"space-between",
        ~marginTop=20.0->Style.dp,
        ())

      <View style>
        <S.Button
          title="Précédent"
          titleStyle=Style.textStyle(~color=Color.black, ())
          mode=#outlined
          onPress={_ => previous()}
        />

        <S.Button
          title="Valider"
          onPress=next
        />
      </View>
    }
  </>
}
