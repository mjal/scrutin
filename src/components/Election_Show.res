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
      L'organisateur vient de creer un bulletin de vote avec cette clé.
    `
    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(email))
      Js.Dict.set(dict, "subject",
        Js.Json.string("Vous êtes invité à un election"))
      Js.Dict.set(dict, "text", Js.Json.string(message))
      Js.Json.object_(dict)
    }
    X.post(`${Config.api_url}/proxy_email`, data)
    -> ignore

    let ballot : Ballot.t = {
      electionTx: eventHash,
      ballotTx:   None,
      ciphertext: None,
      owners: [
        election.ownerPublicKey,
        id.hexPublicKey
      ]
    }

    let electionOwner = Array.getBy(state.ids, (id) => {
      id.hexPublicKey == election.ownerPublicKey
    }) -> Option.getExn

    let tx = Transaction.SignedBallot.make(ballot, electionOwner)
    dispatch(Transaction_Add(tx))
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

    <Divider />

    {
      state.txs
      -> Array.keep((tx) => tx.eventType == "ballot")
      -> Array.keep((tx) => {
        let ballot = Transaction.SignedBallot.unwrap(tx)
        ballot.electionTx == eventHash
      })
      -> Array.map((tx) => {
        let ballot = Transaction.SignedBallot.unwrap(tx)
        <List.Section title=`Ballot ${tx.eventHash}` key=tx.eventHash>
          <List.Item title="ballotTx"
            description=Option.getWithDefault(ballot.ballotTx, "") />
          <List.Item title="cipherText"
            description=Option.getWithDefault(ballot.ciphertext, "") />

          <List.Accordion title="lol">
          {
            Array.mapWithIndex(ballot.owners, (i, hexPublicKey) =>
              <List.Item title=`Owner ${(i+1)->Int.toString}`
                key=hexPublicKey
                description=hexPublicKey
                onPress={_ =>
                  dispatch(Navigate(Identity_Show(hexPublicKey)))}
              />
            ) -> React.array
          }
          </List.Accordion>
        </List.Section>
      }) -> React.array
    }

    //<Election_Booth election />
  </>
}
