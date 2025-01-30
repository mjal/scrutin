@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  // let { t } = ReactI18next.useTranslation()

  let (emails, setEmails) = React.useState(_ => {
    Js.Array2.joinWith(state.emails,"\n")
  })

  let next = _ => {
    let emails = Js.String.split("\n", emails)->Array.map(String.trim)
    setState(_ => {
      ...state,
      step: Step5,
      emails
    })
  }

  let previous = _ => setState(_ => {...state, step: Step3})

  <>
    <Header title="Nouvelle élection" subtitle="4/5" />

    <S.Container>
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
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}

