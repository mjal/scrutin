@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let election = Map.String.getExn(state.cache.elections, eventHash)
  let publicKey = election.ownerPublicKey

  let addBallot = _ => {
    let id = Identity.make()
    let hexSecretKey = Option.getExn(id.hexSecretKey)
    let message = `
      Hello !
      Vous êtes invité à l'election.
      Voici votre clé privée ${hexSecretKey}
      Pour information, la clé publique associée est ${id.hexPublicKey}
      L'organisateur vient de creer un bulletin de vote avec cette clé publique.
    `
    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(email))
      Js.Dict.set(dict, "message", Js.Json.string(message))
      Js.Json.object_(dict)
    }
    X.post(`${Config.api_url}/users/email_confirmation`, data)
    -> ignore

    // Create ballot
  }

  <>
    <List.Section title="Election">

      <List.Item title="Event Hash" description=eventHash />

      {
        let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
        <List.Item title="Owner Public Key" onPress description=publicKey />
      }

      <List.Item title="Params" description=election.params />

      <List.Item title="Trustees" description=election.trustees />

    </List.Section>

    <Divider />

    <TextInput
      mode=#flat
      label="Email"
			value=email
      onChangeText={text => setEmail(_ => text)}
    />

    <Button mode=#outlined onPress=addBallot>
      { "Add as voter" -> React.string }
    </Button>

    //<Election_Booth election />
  </>
}
