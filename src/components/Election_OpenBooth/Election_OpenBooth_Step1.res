@react.component
let make = (~electionData: ElectionData.t, ~state: Election_OpenBooth_State.t, ~dispatch) => {
  let _ = state
  let { setup } = electionData
  let { election } = setup

  <>
    <Header title="Participer à l'élection" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Image source=Logo.source style=Style.viewStyle(~width=180.0->Style.dp, ~height=70.0->Style.dp, ()) />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { `${election.name}`->React.string }
    </Title>

    <S.Button
      title="Je participe"
      onPress={_ => dispatch(Election_OpenBooth_State.SetStep(Step2))}
    />
  </>
}
