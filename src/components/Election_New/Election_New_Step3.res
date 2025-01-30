@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()
  let (access, setAccess) = React.useState(_ => None)

  let next = _ => {
    let step = switch access {
    | Some(#closed) => Election_New_State.Step4
    | _ => Election_New_State.Step5
    }
    setState(_ => {...state, access, step})
  }

  let previous = _ => setState(_ => {...state, step: Step2})

  <>
    <Header title="Nouvelle élection" subtitle="3/5" />

    <S.Container>

      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.H1 text="Comment on y participe ?" />

      <View style=Style.viewStyle(~padding=16.0->Style.dp, ()) />

      <RadioButton.Group
        value={Election.accessToString(access)}
        onValueChange={v => {
          setAccess(_ => Election.stringToAccess(v))
          v
        }}
      >
        <TouchableOpacity onPress={_ => setAccess(_ => Some(#"open"))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="open" status=(if access == Some(#"open") { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Participation par lien ouvert"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "Les participant·es peuvent rejoindre librement l'élection grâce à un lien ou un QR code."
              ->React.string
            }
          </Text>
        </TouchableOpacity>

        <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

        <TouchableOpacity onPress={_ => setAccess(_ => Some(#closed))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="closed" status=(if access == Some(#"closed") { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Participation par email"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "L’administrateur·ice de l’élection doit inviter chaque participant·e via une liste d’e-mails."
              ->React.string
            }
          </Text>
        </TouchableOpacity>
      </RadioButton.Group>
    </S.Container>

    <Election_New_Previous_Next next previous disabled=Option.isNone(access) />
  </>
}

