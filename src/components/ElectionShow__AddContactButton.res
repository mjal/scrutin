@react.component
let make = (~contentHash) => {
  let (state, dispatch) = Context.use()
  let (showModal, setshowModal) = React.useState(_ => false);

  let election = Map.String.getExn(state.cached_elections, contentHash)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  }) -> Option.getExn

  let onSelect = (contact : Contact.t) => {
    let ballot : Ballot.t = {
      electionTx: contentHash,
      previousTx: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: contact.hexPublicKey
    }

    let tx = Transaction.SignedBallot.make(ballot, orgId)
    dispatch(Transaction_Add_With_Broadcast(tx))

    setshowModal(_ => false)
  }

  <>
    <Button mode=#outlined onPress={_ => setshowModal(_ => true)}>
      { "Add existing contact" -> React.string }
    </Button>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="choice-modal">

          <Title style=X.styles["title"]>
            { "Invite an existing contact" -> React.string }
          </Title>

          { Array.map(state.contacts, (contact) => {
            <List.Item
              title=Option.getWithDefault(contact.email, "")
              onPress={_ => onSelect(contact)}
            />
          }) -> React.array }

          <Button onPress={_ => { setshowModal(_ => false)} }>
            { "Retour" -> React.string }
          </Button>
        </View>
      </Modal>
    </Portal>
  </>
}

