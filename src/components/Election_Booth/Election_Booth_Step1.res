@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = state
  let { setup } = electionData
  let { election } = setup


  let getSecret = () => {
    if ReactNative.Platform.os == #web {
      let url = RescriptReactRouter.dangerouslyGetInitialUrl()
      if String.length(url.hash) > 12 { Some(url.hash) } else { None }
    } else {
      None
    }
  }

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step2
    })
  }

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
      onPress=next
    />
  </>
}
