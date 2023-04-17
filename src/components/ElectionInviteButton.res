@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (showModal, setshowModal) = React.useState(_ => false);
  let (inviteUrl, setInviteUrl) = React.useState(_ => "");

  let election = State.getElectionExn(state, electionId)

  let orgId = State.getAccountExn(state, election.ownerPublicKey)

  let createInvite = _ => {
    let voterId = Account.make() // Only use if no contact found

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
    
    setInviteUrl(_ => `${URL.base_url}/ballots/${ballotId}#${secretKey}`)
    setshowModal(_ => true)
  }

  <>
    <ElectionHeader election section=#inviteLink />

    <View style=Style.viewStyle(~margin=30.0, ())>
      <Text style=Style.textStyle(
          ~width=600.0->Style.dp, ~alignSelf=#center,
          ())>
        { inviteUrl -> React.string }
      </Text>
    </View>

    <Button mode=#outlined onPress={_ => {
      Clipboard_.writeText(inviteUrl) -> ignore }
    }>
      { t(."election.show.createInvite.copy") -> React.string }
    </Button>

    } else {
      <Button mode=#outlined onPress={_ => { Share.share({ message: inviteUrl}) -> ignore } }>
        { t(."election.show.createInvite.share") -> React.string }
      </Button>
    } }

    <Button mode=#outlined onPress={_ => { setshowModal(_ => false)} }>
      { t(."election.show.createInvite.close") -> React.string }
    </Button>
  </>
}
