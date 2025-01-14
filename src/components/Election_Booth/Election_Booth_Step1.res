@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = state
  let { setup } = electionData
  let { credentials, election } = setup


  let getSecret = () => {
    if ReactNative.Platform.os == #web {
      let url = RescriptReactRouter.dangerouslyGetInitialUrl()
      if String.length(url.hash) > 12 { Some(url.hash) } else { None }
    } else {
      None
    }
  }

  let secret = React.useMemo(_ => {
    getSecret()
  })

  let priv = secret->Option.flatMap((secret) => {
    let { pub } = Credential.derive(election.uuid, secret)
    if Array.some(credentials, (c) => c == pub) {
      Some(secret)
    } else {
      None
    }
  })

  let next = _ => {
    let step = switch priv {
    | None    => Election_Booth_State.Step2
    | Some(_) => Election_Booth_State.Step3
    }
    setState(_ => {
      ...state,
      step,
      priv
    })
  }

  <>
    <Header title="Participer à l'élection" />

    <View style=Style.viewStyle(~margin=10.0->Style.dp, ()) />

    <Image source=Logo.source style=Style.viewStyle(~width=180.0->Style.dp, ~height=70.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { `${election.name}`->React.string }
    </Title>

    { switch priv {
    | Some(_) =>
      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Vous êtes invité·e à voter à cette élection." -> React.string }
        </Text>

        <S.Button
          title="Je participe"
          onPress=next
        />
      </>
    | None =>
      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Vous n'avez pas d'invitation pour cette élection." -> React.string }
        </Text>
        //{ switch election.access {
        //| Some("open") =>
          <S.Button
            title="Participer en tant qu'invité·e"
            onPress=next
          />
        //| _ => <></>
        //} }
      </>
    } }
  </>
}
