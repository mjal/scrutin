@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (showModal, setshowModal) = React.useState(_ => false);

  let election = State.getElection(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  }) -> Option.getExn

  let onSubmit = _ => {
    let voterId = Identity.make()

    let contact : Contact.t = {
      hexPublicKey: voterId.hexPublicKey,
      email: Some(email),
      phoneNumber: None
    }

    dispatch(Contact_Add(contact))

    let ballot : Ballot.t = {
      electionTx: electionId,
      previousTx: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: voterId.hexPublicKey
    }

    let tx = Transaction.SignedBallot.make(ballot, orgId)
    dispatch(Transaction_Add_With_Broadcast(tx))

    if Config.env == #dev {
      Js.log(voterId.hexSecretKey)
    } else {
      let ballotId = tx.contentHash
      Mailer.send(ballotId, orgId, voterId, email)
    }

    setEmail(_ => "")
    setshowModal(_ => false)
  }

  <>
    <Button mode=#outlined onPress={_ => setshowModal(_ => true)}>
      { "Add voter by email" -> React.string }
    </Button>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="choice-modal">
          <Title style=X.styles["title"]>
            { "Invite someone by email" -> React.string }
          </Title>

          <TextInput
            mode=#flat
            label="Email"
            value=email
            onChangeText={text => setEmail(_ => text)}
            autoFocus=true
            onSubmitEditing=onSubmit
          />

          <X.Row>
            <X.Col>
              <Button onPress={_ => { setEmail(_ => ""); setshowModal(_ => false)} }>{"Retour"->React.string}</Button>
            </X.Col>
            <X.Col>
              <Button mode=#outlined onPress=onSubmit>
                { "Add as voter" -> React.string }
              </Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
    </Portal>
  </>
}
