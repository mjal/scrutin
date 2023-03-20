@react.component
let make = (~contentHash) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)
  let election = Map.String.getExn(state.cached_elections, contentHash)
  let publicKey = election.ownerPublicKey

  let ballots =
    state.txs
    -> Array.keep((tx) => tx.type_ == #ballot)
    -> Array.keep((tx) => {
      let ballot = Transaction.SignedBallot.unwrap(tx)
      ballot.electionTx == contentHash
    })

  let nbBallots = Array.length(ballots)

  let nbBallotsWithCiphertext = Array.keep(ballots, (tx) => {
    let ballot = Transaction.SignedBallot.unwrap(tx)
    ballot.electionTx == contentHash
  }) -> Array.length

  let progress  = `${nbBallotsWithCiphertext -> Int.toString} votes / ${nbBallots -> Int.toString}`

  let addBallot = _ => {
    let voterId = Identity.make()

    let contact : Contact.t = {
      hexPublicKey: voterId.hexPublicKey,
      email: Some(email),
      phoneNumber: None
    }

    dispatch(Contact_Add(contact))

    let ballot : Ballot.t = {
      electionTx: contentHash,
      previousTx: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: voterId.hexPublicKey
    }

    let orgId = Array.getBy(state.ids, (id) => {
      id.hexPublicKey == election.ownerPublicKey
    }) -> Option.getExn

    let tx = Transaction.SignedBallot.make(ballot, orgId)
    dispatch(Transaction_Add_With_Broadcast(tx))

    if Config.env == #dev {
      Js.log(voterId.hexSecretKey)
    } else {
      let ballotId = tx.contentHash
      Mailer.send(ballotId, orgId, voterId, email)
    }
  }

  <>
    <List.Section title="Election">

      <List.Item title="Name" description=Election.name(election) />

      <List.Item title="Description"
        description=Election.description(election) />

      <List.Item title="Progress"
        description=progress />

      { if showAdvanced {
        <>
          <List.Item title="Event Hash" description=contentHash />

          {
            let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
            <List.Item title="Owner Public Key" onPress description=publicKey />
          }

          <List.Item title="Params" description=election.params />

          <List.Item title="Trustees" description=election.trustees />
        </>
      } else { <></> } }

      <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
        { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
      </Button>

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

    <Button mode=#outlined onPress={_ =>
      Core.Election.tally(~electionEventHash=contentHash)(state, dispatch)
    }>
      { "Tally" -> React.string }
    </Button>
  </>
}
