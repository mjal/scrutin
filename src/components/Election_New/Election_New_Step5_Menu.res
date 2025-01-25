type policy_t = option<[ #local | #file | #extern ]>

let policyToString = (policy: policy_t): string => {
  switch policy {
  | Some(#local) => "local"
  | Some(#file) => "file"
  | Some(#extern) => "extern"
  | None => ""
  }
}

let stringToPolicy = (value: string): policy_t => {
  switch value {
  | "local" => Some(#local)
  | "file" => Some(#file)
  | "extern" => Some(#extern)
  | _ => None
  }
}

@react.component
let make = (~updatePolicy) => {
  let (policy : policy_t, setPolicy) = React.useState(_ => None)

  <>
    <S.H1 text="Sauvegarde du mot de passe nécessaire au dépouillement" />

    <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
      <RadioButton.Group
        value={policyToString(policy)}
        onValueChange={v => { setPolicy(_ => stringToPolicy(v)); v }}
      >
        <TouchableOpacity onPress={_ => setPolicy(_ => Some(#local))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="local" status=(if policy == Some(#local) { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Sur cet appareil"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            { "Vous aurez besoin de cet appareil pour le dépouillement." -> React.string }
          </Text>
        </TouchableOpacity>

        <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

        <TouchableOpacity onPress={_ => setPolicy(_ => Some(#file))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="file" status=(if policy == Some(#file) { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Dans un fichier"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "Vous sauvegardez le mot de passe dans un fichier que vous devrez utiliser pour le dépouillement." -> React.string
            }
          </Text>
        </TouchableOpacity>

        <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

        <TouchableOpacity onPress={_ => setPolicy(_ => Some(#extern))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="extern" status=(if policy == Some(#extern) { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Sauvegarde externe"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "Vous notez le mot de passe dans un gestionnaire de mot de passe, sur du papier, ou dans une messagerie chiffrée" -> React.string
            }
          </Text>
        </TouchableOpacity>
      </RadioButton.Group>

      <S.Row>
        <S.Col>
          <></>
        </S.Col>
        <S.Col>
          <S.Button
            title="Suivant"
            disabled=Option.isNone(policy)
            onPress={ _ => updatePolicy(_ => policy) }
            />
        </S.Col>
      </S.Row>
    </View>
  </>
}
