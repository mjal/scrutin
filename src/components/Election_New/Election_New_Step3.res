@react.component
let make = (~state: Election_New_State.t, ~dispatch) => {
  let { t } = ReactI18next.useTranslation()
  let _ = state
  let (access, setAccess) = React.useState(_ => None)

  let next = _ => {
    dispatch(Election_New_State.SetAccess(Option.getExn(access)))
    switch access {
    | Some(#closed) => dispatch(Election_New_State.SetStep(Step4))
    | _ => dispatch(Election_New_State.SetStep(Step5))
    }
  }

  <>
    <Header title="Nouvelle élection" subtitle="3/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Comment participer ?" -> React.string }
    </Title>

    <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
      <RadioButton.Group
        value={Election_New_State.accessToString(access)}
        onValueChange={v => {
          setAccess(_ => Election_New_State.stringToAccess(v))
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
              { "Participation ouverte"->React.string }
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
    </View>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
}
