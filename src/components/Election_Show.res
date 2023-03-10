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
let make = (~contentHash) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (hexSecretKey, setSecretKey) = React.useState(_ => "") // NOTE: Only for dev
  let election = Map.String.getExn(state.cached_elections, contentHash)
  let publicKey = election.ownerPublicKey

  let (visible, setVisible) = React.useState(_ => false)
  let (message, setMessage) = React.useState(_ => "")

  let ballots =
    state.txs
    -> Array.keep((tx) => tx.type_ == #ballot)
    -> Array.keep((tx) => {
      let ballot = Transaction.SignedBallot.unwrap(tx)
      ballot.electionTx == contentHash
    })

  let nbBallots = Array.length(ballots)

  let addBallot = _ => {
    let id = Identity.make()
    let hexSecretKey = Option.getExn(id.hexSecretKey)

    let ballot : Ballot.t = {
      electionTx: contentHash,
      previousTx: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: id.hexPublicKey
    }

    let electionOwner = Array.getBy(state.ids, (id) => {
      id.hexPublicKey == election.ownerPublicKey
    }) -> Option.getExn

    let tx = Transaction.SignedBallot.make(ballot, electionOwner)
    dispatch(Transaction_Add(tx))

    let message = `
      Hello !
      Vous êtes invité à une election.
      Cliquez ici pour voter :
      https://scrutin.app/ballots/${tx.contentHash}#${hexSecretKey}
    `

    let time = Js.Date.now() -> Float.toInt
    let hexTime = Js.Int.toStringWithRadix(time, ~radix=16)
    let hexSignedTime = Identity.signHex(electionOwner, hexTime)

    // For email
    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(email))
      Js.Dict.set(dict, "subject",
        Js.Json.string("Vous êtes invité à un election"))
      Js.Dict.set(dict, "text", Js.Json.string(message))
      Js.Dict.set(dict, "time", Js.Json.string(Int.toString(time)))
      Js.Dict.set(dict, "hexSignedTime", Js.Json.string(hexSignedTime))
      Js.Json.object_(dict)
    }
    let _ = data
    X.post(`${Config.api_url}/proxy_email`, data)
    -> ignore

  }

  <>
    <List.Section title="Election">

      <List.Item title="Event Hash" description=contentHash />

      {
        let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
        <List.Item title="Owner Public Key" onPress description=publicKey />
      }

      <List.Item title="Params" description=election.params />

      <List.Item title="Trustees" description=election.trustees />

    </List.Section>

    <Divider />

    <Title style=X.styles["title"]>
      { "Invite someone" -> React.string }
    </Title>

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
        <List.Item title=`Ballot ${tx.contentHash}`
          key=tx.contentHash
          onPress={_ => dispatch(Navigate(Ballot_Show(tx.contentHash)))}
        />
      }) -> React.array
    }
    </List.Section>

    <MessageModal visible setVisible message hexSecretKey />
    //<Election_Booth election />

    <Button mode=#outlined onPress={_ =>
      Core.Election.tally(~electionEventHash=contentHash)(state, dispatch)
    }>
      { "Tally" -> React.string }
    </Button>
  </>
}
