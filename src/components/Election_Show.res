@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let election = Map.String.getExn(state.cache.elections, eventHash)
  let publicKey = election.ownerPublicKey

  let ballots =
    state.txs
    -> Array.keep((tx) => tx.eventType == "ballot")
    -> Array.keep((tx) => {
      let ballot = Transaction.SignedBallot.unwrap(tx)
      ballot.electionTx == eventHash
    })

  let nbBallots = Array.length(ballots)

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
      previousTx: None,
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

    <List.Section title=`${nbBallots -> Int.toString} ballots`>
    {
      Array.map(ballots, (tx) => {
        let _ballot = Transaction.SignedBallot.unwrap(tx)
        <List.Item title=`Ballot ${tx.eventHash}`
          key=tx.eventHash
          onPress={_ => dispatch(Navigate(Ballot_Show(tx.eventHash)))}
        />
      }) -> React.array
    }
    </List.Section>

    //<Election_Booth election />
  </>
}
