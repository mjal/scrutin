let policyToString = (policy) : string => {
  switch policy {
  | Some(#local) => "local"
  | Some(#file) => "file"
  | Some(#extern) => "extern"
  | None => ""
  }
}
let stringToPolicy = (value: string)  => {
  switch value {
  | "local" => Some(#local)
  | "file" => Some(#file)
  | "extern" => Some(#extern)
  | _ => None
  }
}

@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let (passwordPolicy, setPasswordPolicy) = React.useState(_ => state.passwordPolicy)
  let next = _ => setState(_ => {...state, ?passwordPolicy})
  let previous = _ => setState(_ => {...state, step: Step4})

  let options : array<RadioButtonGroup.option_t> = [
    Some({
      value: "local",
      title: <RadioButtonGroup.SimpleTitle text="Sur cet appareil" />,
      content: <RadioButtonGroup.SimpleContent text="Vous aurez besoin de cet appareil pour le dépouillement." />
    } : RadioButtonGroup.option_t),
    switch ReactNative.Platform.os {
    | #web =>
      Some({
        value: "file",
        title: <RadioButtonGroup.SimpleTitle text="Dans un fichier" />,
        content: <RadioButtonGroup.SimpleContent text="Vous sauvegardez le mot de passe dans un fichier que vous devrez utiliser pour le dépouillement." />
      })
    | _ => None
    },
    Some({
      value: "extern",
      title: <RadioButtonGroup.SimpleTitle text="Sauvegarde externe" />,
      content: <RadioButtonGroup.SimpleContent text="Vous notez le mot de passe dans un gestionnaire de mot de passe, sur du papier, ou dans une messagerie chiffrée" />
    })
  ]->Array.keep(Option.isSome)->Array.map(Option.getExn)

  <>
    <S.Container>
      <S.H1 text="Sauvegarde du mot de passe nécessaire au dépouillement" />

      <RadioButtonGroup
        value=policyToString(passwordPolicy)
        onValueChange={ v => {
          setPasswordPolicy(_ => stringToPolicy(v))
          v
        } }
        options
        />
    </S.Container>

    <Election_New_Previous_Next
      next
      previous
      disabled=Option.isNone(passwordPolicy)
    />
  </>
}
