@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  let { t } = ReactI18next.useTranslation()
  let (emails, setEmails) = React.useState(_ => "")
  let _ = (state, dispatch)

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

    <S.Button
      title={t(. "election.new.next")}
      onPress={_ => dispatch(ElectionNewState.SetStep(Step5)) }
      />
  </>
}

