@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = (electionData, state)
  let (name, setName) = React.useState(_ => "")

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step3,
      name: Some(name),
    })
  }

  <>
    <Header title="S'identifier" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />
  
    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Qui êtes-vous ?" -> React.string }
    </Title>
  
    <S.TextInput placeholder="Votre nom"
      value=name
      onChangeText={text => setName(_ => text)}
    />
  
    <S.Button
      title="Valider"
      onPress=next
    />
  </>
}
