@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let { t } = ReactI18next.useTranslation()
  let (emails, setEmails) = React.useState(_ => "")

  let next = _ => {
    let emails = Js.String.split("\n", emails)->Array.map(String.trim)
    Js.log(emails)
    setState(_ => {
      ...state,
      step: Step5,
      emails
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="4/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ())>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { "Ajouter les emails des participants" -> React.string }
      </Title>
    </View>

    <S.TextInput
      testID="election-emails"
      value=emails
      placeholder="Emails des participants"
      placeholderTextColor="#bbb"
      autoFocus=true
      multiline=true
      numberOfLines=10
      onChangeText={text => setEmails(_ => text)}
    />

    <Election_New_Previous_Next next previous={_ => setState(_ => {...state, step: Step3})} />
  </>
}

