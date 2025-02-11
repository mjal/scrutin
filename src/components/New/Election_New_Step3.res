@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()
  let next = _ => {
    let step = switch state.access {
    | Some(#closed) => Election_New_State.Step4
    | _ => Election_New_State.Step_Password_Disclaimer
    }
    setState(_ => {...state, step})
  }

  let previous = _ => setState(_ => {...state, step: Step2})

  let options : array<RadioButtonGroup.option_t> = [
    {
      value: "open",
      title: <RadioButtonGroup.SimpleTitle text="Participation ouverte" />,
      content: <RadioButtonGroup.SimpleContent text="Les participant·es peuvent rejoindre librement l'élection grâce à un lien ou un QR code." />
    },
    {
      value: "closed",
      title: <RadioButtonGroup.SimpleTitle text="Participation fermée" />,
      content: <RadioButtonGroup.SimpleContent text="L’administrateur·ice de l’élection doit inviter chaque participant·e via une liste d’e-mails." />
    }
  ]

  <>
    <Header title="Nouvelle élection" subtitle="3/5" />

    <S.Container>

      <S.H1 text="Comment on y participe ?" />

      <RadioButtonGroup
        value=Election.accessToString(state.access)
        onValueChange={ v => {
          let access = Election.stringToAccess(v)
          setState(_ => {...state, ?access }); v
        } }
        options
        />

    </S.Container>

    <Election_New_Previous_Next next previous disabled=Option.isNone(state.access) />
  </>
}

