@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (showModal, setshowModal) = React.useState(_ => false);
  let (inviteUrl, setInviteUrl) = React.useState(_ => "");

  let election = State.getElectionExn(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  }) -> Option.getExn

  let createInvite = _ => {
    let voterId = Identity.make() // Only use if no contact found

    let ballot : Ballot.t = {
      electionId,
      previousId: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: voterId.hexPublicKey
    }

    let tx = Event_.SignedBallot.create(ballot, orgId)
    dispatch(Event_Add_With_Broadcast(tx))

    let ballotId = tx.contentHash
    let secretKey = Option.getExn(voterId.hexSecretKey)
    
    setInviteUrl(_ => j`${URL.base_url}/ballots/$ballotId#$secretKey`)
    setshowModal(_ => true)
  }

  <>
    <Button mode=#contained onPress=createInvite>
      { t(."election.show.createInvite.button") -> React.string }
    </Button>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="invite-modal">
          <Title style=X.styles["title"]>
            {
              t(."election.show.createInvite.share")  -> React.string
            }
          </Title>

          <Text style=Style.textStyle(
              ~width=600.0->Style.dp,
              ~alignSelf=#center,
              ()
            )>
            { inviteUrl -> React.string }
          </Text>

          <Button onPress={_ => { setshowModal(_ => false)} }>
            { t(."election.show.createInvite.close") -> React.string }
          </Button>

        </View>
      </Modal>
    </Portal>
  </>
}

