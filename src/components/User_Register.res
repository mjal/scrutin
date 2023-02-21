open ReactNative
open! Paper

@react.component
let make = () => {
  let (email, setEmail) = React.useState(_ => "")
  let (loading, setLoading) = React.useState(_ => false)
  let (_state, dispatch) = Context.use()
  let (error, setError) = React.useState(_ => "")

  let onSubmit = _ => {
    if !EmailValidator.validate(email) {
      setError(_ => "Invalid email")
    } else {
      setLoading(_ => true)
      dispatch(Action.Member_Register(email))
    }
  }

  <>
    <Title style=X.styles["center"]> { "Ready to vote ?" -> React.string } </Title>

    { if error == "" { <></> } else {
      <HelperText _type=#error>
        { error -> React.string }
      </HelperText>
    } }

    <TextInput
      mode=#flat
      label="Email"
      testID="email-input"
      value=email
      onChangeText={text => setEmail(_ => text)}
      onSubmitEditing=onSubmit
    />

    <Button mode=#contained onPress=onSubmit>
      {loading ? "Loading..." -> React.string : "Next" -> React.string}
    </Button>
  </>
}