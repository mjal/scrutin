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
  | None => true
  }

  <>
    <Header title="Participer à l'élection" />

    <View style=Style.viewStyle(~margin=10.0->Style.dp, ()) />

    <Image source=Logo.source style=Style.viewStyle(~width=180.0->Style.dp, ~height=70.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~lineHeight=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style=Style.viewStyle(~marginHorizontal=40.0->Style.dp, ())>
      <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
        { `${election.description}`->React.string }
      </Text>
    </View>
  
    { switch result {
    | None =>
      { switch priv {
      | Some(_) =>
        if (Array.some(ballots, (b) => Some(b.credential) == pub)) {
          <>
            <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
              { "Vous avez déjà voté à cette élection." -> React.string }
            </Text>
          </>
        } else {
          <>
            <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
              { "Vous êtes invité·e à voter à cette élection." -> React.string }
            </Text>

            { if started {
              <S.Button
                title="Je participe"
                onPress=next
              />
            } else if ended {
              <>
                <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
                  { `La periode de vote est closee.` -> React.string }
                </Text>

                <S.Button
                  title="Page de l'élection"
                  onPress={_ => {
                    globalDispatch(Navigate(list{"elections", election.uuid}))
                  }}
                />
              </>
            } else {
              <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
                { `L'élection commencera à ${Js.Date.toLocaleString(Option.getExn(election.startDate))}.` -> React.string }
              </Text>
            }}
          </>
        }
      | None =>
        <>
          <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
            { "Vous n'avez pas d'invitation pour cette élection." -> React.string }
          </Text>
          //{ switch election.access {
          //| Some("open") =>
            { if started {
              <S.Button
                title="Participer en tant qu'invité·e"
                onPress=next
              />
            } else if ended {
              <>
                <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
                  { `La periode de vote est closee.` -> React.string }
                </Text>

                <S.Button
                  title="Page de l'élection"
                  onPress={_ => {
                    globalDispatch(Navigate(list{"elections", election.uuid}))
                  }}
                />
              </>
            } else {
              <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
                { `L'élection commence: ${Js.Date.toLocaleString(Option.getExn(election.startDate))}.` -> React.string }
              </Text>
            }}
          //| _ => <></>
          //} }
        </>
      } }
    | Some(_) =>
      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
          { "Cette élection est terminée." -> React.string }
        </Text>

        <S.Button
          title="Page de l'élection"
          onPress={_ => {
            globalDispatch(Navigate(list{"elections", election.uuid}))
          }}
        />
      </>
    }}
  </>
}
