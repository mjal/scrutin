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

  let options : array<RadioButtonGroup.option_t> = [
    {
      value: "open",
      title: <RadioButtonGroup.SimpleTitle text="Participation par lien ouvert" />,
      content: <RadioButtonGroup.SimpleContent text="Les participant·es peuvent rejoindre librement l'élection grâce à un lien ou un QR code." />
    },
    {
      value: "closed",
      title: <RadioButtonGroup.SimpleTitle text="Participation par email" />,
      content: <RadioButtonGroup.SimpleContent text="L’administrateur·ice de l’élection doit inviter chaque participant·e via une liste d’e-mails." />
    }
  ]

  <>
    <Header title="Nouvelle élection" subtitle="3/5" />

    <S.Container>

      <S.H1 text="Comment on y participe ?" />

      <RadioButtonGroup
        value=Election.accessToString(access)
        onValueChange={ v => { setState(_ => {...state, access: Election.stringToAccess(v)}); v } }
        options
        />

    </S.Container>

    <Election_New_Previous_Next next previous disabled=Option.isNone(access) />
  </>
}

