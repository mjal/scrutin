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

    <S.H1 text=election.name />

    <View style=Style.viewStyle(~marginHorizontal=40.0->Style.dp, ())>
      <Text>
        { `${election.description}`->React.string }
      </Text>
    </View>

    { if started && !ended {
      <S.P text=`La periode de vote est ouverte.` />
    } else if ended {
      <S.P text=`La periode de vote est close.` />
    } else {
      <S.P text=`L'élection commencera à ${Js.Date.toLocaleString(Option.getExn(election.startDate))}.` />
    } }

    { switch priv {
    | Some(_) =>
    <>
      <S.P text="Vous êtes invité·e à voter à cette élection." />

      { if alreadyVoted {
        <S.P text="Vous avez déjà voté à cette élection." />
      } else { <></> }}
    </>
    | None =>
      switch election.access {
      | Some(#"open") =>
        <S.P text="Vous pouvez participer en tant qu'invité." />
      | _ =>
        <S.P text="Vous n'êtes pas d'invitation pour cette élection." />
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
      <S.P text="Cette élection est terminée." />
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
