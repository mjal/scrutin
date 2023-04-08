@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (email, setEmail) = React.useState(_ => "")
  let (contact:option<Contact.t>, setContact) = React.useState(_ => None)
  let (showModal, setshowModal) = React.useState(_ => false);

  let election = State.getElection(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  }) -> Option.getExn

  let onChangeText = text => {
    setEmail(_ => text)
    let contact = Array.getBy(state.contacts, (contact) => {
      Option.getWithDefault(contact.email, "") == text
    })
    setContact(_ => contact)
  }

  let onSubmit = _ => {
    let voterId = Identity.make() // Only use if no contact found

    // NOTE: This is to disable the "Use existing contact feature"
    let contact:option<Contact.t> = None

    if Option.isNone(contact) {
      let contact : Contact.t = {
        hexPublicKey: voterId.hexPublicKey,
        email: Some(email),
        phoneNumber: None
      }

      dispatch(Contact_Add(contact))
    }

    let voterPublicKey = switch (contact) {
    | Some(contact) => contact.hexPublicKey
    | None => voterId.hexPublicKey
    }

    let ballot : Ballot.t = {
      electionId,
      previousTx: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey
    }

    let tx = Event_.SignedBallot.make(ballot, orgId)
    dispatch(Event_Add_With_Broadcast(tx))

    if Option.isNone(contact) {
      if X.env == #dev {
        Js.log(voterId.hexSecretKey)
      } else {
        let ballotId = tx.contentHash
        Mailer.send(ballotId, orgId, voterId, email)
      }
    }

    setEmail(_ => "")
    setshowModal(_ => false)
  }

  <>
    <Button mode=#contained onPress={_ => setshowModal(_ => true)}>
      { t(."election.show.addByEmail.addParticipant") -> React.string }
    </Button>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="choice-modal">
          <Title style=X.styles["title"]>
            {
              t(."election.show.addByEmail.modal.title")  -> React.string
            }
          </Title>

          <TextInput
            mode=#flat
            label=t(."election.show.addByEmail.modal.email")
            value=email
            onChangeText
            autoFocus=true
            onSubmitEditing=onSubmit
          />

          <X.Row>
            <X.Col>
              <Button onPress={_ => { setEmail(_ => ""); setshowModal(_ => false)} }>
                { t(."election.show.addByEmail.modal.back") -> React.string }
              </Button>
            </X.Col>
            <X.Col>
              <Button mode=#outlined onPress=onSubmit>
                { /*if Option.isSome(contact) {
                  "Utiliser le contact existant" -> React.string
                } else */{
                  { t(."election.show.addByEmail.modal.sendInvite") -> React.string }
                } }
              </Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
    </Portal>
  </>
}
