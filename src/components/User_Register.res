open ReactNative
open! Paper

@react.component
let make = () => {
  let (email, setEmail) = React.useState(_ => "")
  let (loading, setLoading) = React.useState(_ => false)

  <>
    <Title style=X.styles["center"]> { "Ready to vote ?" -> React.string } </Title>

    <TextInput
      mode=#flat
      label="Email"
      testID="email-input"
      value=email
      onChangeText={text => setEmail(_ => text)}
    />

    <Button mode=#contained onPress={_ => {
      setLoading(_ => true)
      Context.dispatch(Action.Navigate(Route.User_Register_Confirm))
    }}>
      {loading ? "Loading..." -> React.string : "Next" -> React.string}
    </Button>
  </>
}