module MessageModal = {
  @react.component
  let make = (~message, ~visible, ~setVisible, ~hexSecretKey) => {
    let (_state, dispatch) = Context.use()
    <Portal>
      <Modal visible={visible} onDismiss={_ => setVisible(_ => false)}>
        <View
          style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])
          testID="choice-modal">
          <Text>{ message -> React.string }</Text>
          <Button onPress={_ => {
            dispatch(Identity_Add(Identity.make2(~hexSecretKey)))
          }}>
            { "Add identity (dev)" -> React.string }
          </Button>
        </View>
      </Modal>
    </Portal>
  }
}

@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (hexSecretKey, setSecretKey) = React.useState(_ => "") // NOTE: Only for dev
  let election = Map.String.getExn(state.cache.elections, eventHash)
  let publicKey = election.ownerPublicKey

  let (visible, setVisible) = React.useState(_ => false)
  let (message, setMessage) = React.useState(_ => "")

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

    setMessage(_ => message)
    setSecretKey(_ => hexSecretKey)
    setVisible(_ => true)

    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(email))
      Js.Dict.set(dict, "subject",
        Js.Json.string("Vous êtes invité à un election"))
      Js.Dict.set(dict, "text", Js.Json.string(message))
      Js.Json.object_(dict)
    }
    let _ = data
    //X.post(`${Config.api_url}/proxy_email`, data)
    //-> ignore

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

  let tally = _ => {
    let params = Belenios.Election.parse(election.params)
    let trustees = Belenios.Trustees.of_str(election.trustees)
    let trustee = Array.getBy(state.trustees, (trustee) => {
      Belenios.Trustees.pubkey(trustees) ==
      Belenios.Trustees.pubkey(trustee.trustees)
    })
    let privkey = Option.getExn(trustee).privkey

    let (pubcreds, privcreds) =
      Belenios.Credentials.create(params.uuid, Array.length(ballots))

    let ciphertexts =
      ballots
      -> Array.map(Transaction.SignedBallot.unwrap)
      -> Array.map((ballot) => ballot.ciphertext)
      -> Array.keep((ciphertext) => Option.getWithDefault(ciphertext, "") != "")
      -> Array.map((ciphertext) => Belenios.Ballot.of_str(Option.getExn(ciphertext)))
      -> Array.mapWithIndex((i, ballot) => {
        Belenios.Ballot.setCredential(ballot, Array.getExn(pubcreds, i))
      })

    Js.log(ciphertexts)

    let (a, b) = Belenios.Election.decrypt(params, ciphertexts, trustees, pubcreds, privkey)
    let res = Belenios.Election.result(params, ciphertexts, trustees, pubcreds, a, b)
    Js.log(res)
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

    //<TextInput
    //  mode=#flat
    //  label="Email"
		//	value=email
    //  onChangeText={text => setEmail(_ => text)}
    ///>

    <Button mode=#outlined onPress=addBallot>
      { "Add a voter" -> React.string }
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

    <MessageModal visible setVisible message hexSecretKey />
    //<Election_Booth election />

    <Button mode=#outlined onPress=tally>
      { "Tally" -> React.string }
    </Button>
  </>
}
