@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = state
  let { setup, result, ballots } = electionData
  let { credentials, election } = setup
  let ( _, globalDispatch ) = StateContext.use()


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

  let pub = Option.flatMap(secret, (secret) => Some(Credential.derive(election.uuid, secret).pub))

  let priv = pub->Option.flatMap((pub) => {
    if Array.some(credentials, (c) => c == pub) {
      secret
    } else {
      None
    }
  })

  let alreadyVoted = Array.some(ballots, (b) => Some(b.credential) == pub)

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

  let started = switch election.startDate {
  | Some(startDate) => startDate < Js.Date.fromFloat(Js.Date.now())
  | None => true
  }

  let ended = switch election.endDate {
  | Some(endDate) => endDate < Js.Date.fromFloat(Js.Date.now())
  | None => false
  }

  <>
    <Header title="Participer à l'élection" />

    <View style=Style.viewStyle(~margin=10.0->Style.dp, ()) />

    <Image source=Logo.source style=Style.viewStyle(~width=180.0->Style.dp, ~height=70.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~lineHeight=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style=Style.viewStyle(~marginHorizontal=40.0->Style.dp, ())>
      <Text>
        { `${election.description}`->React.string }
      </Text>
    </View>

    { if started && !ended {
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { `La periode de vote est ouverte.` -> React.string }
      </Text>
    } else if ended {
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { `La periode de vote est close.` -> React.string }
      </Text>
    } else {
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { `L'élection commencera à ${Js.Date.toLocaleString(Option.getExn(election.startDate))}.` -> React.string }
      </Text>
    } }

    { switch priv {
    | Some(_) =>
    <>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { "Vous êtes invité·e à voter à cette élection." -> React.string }
      </Text>

      { if alreadyVoted {
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Vous avez déjà voté à cette élection." -> React.string }
        </Text>
      } else { <></> }}
    </>
    | None =>
      switch election.access {
      | Some(#"open") =>
        <>
          <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
            { "Vous pouvez participer en tant qu'invité." -> React.string }
          </Text>
        </>
      | _ =>
        <>
          <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
            { "Vous n'êtes pas d'invitation pour cette élection." -> React.string }
          </Text>
        </>
      }
    } }


    { switch result {
    | None =>
      { if started && !ended {
        if election.access == Some(#"open") || priv != None {
          <S.Button
            title=(alreadyVoted ? "Revoter" : "Je participe")
            onPress=next
          />
        } else { <></> }
      } else { <></> } }
    | Some(_) =>
      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
          { "Cette élection est terminée." -> React.string }
        </Text>
      </>
    } }

    <S.Button
      title="Page de l'élection"
      titleStyle=Style.textStyle(~color=Color.black, ())
      mode=#outlined
      onPress={_ => {
        globalDispatch(Navigate(list{"elections", election.uuid}))
      }}
    />
  </>
}
