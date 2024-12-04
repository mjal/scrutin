@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()

  let (emails, setEmails) = React.useState(_ => "")

  let next = _ => {
    // Split emails by newline
    let emails = Js.String.split("\n", emails)
    let newElection = {...state.newElection, emails: emails}
    dispatch(StateMsg.UpdateNewElection(newElection))
    dispatch(StateMsg.CreateClosedElection)
  }

  <>
    <Header title={"Créer une nouvelle élection"} />
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
      title={"Suivant"}
      disabled=(emails == "")
      onPress=next
    />
  </>
}
