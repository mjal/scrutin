module CopyButton = {
  @react.component
  let make = (~inviteUrl) => {
    let { t } = ReactI18next.useTranslation()
    let (visible, setVisible) = React.useState(_ => false);

    <>
      <S.Button onPress={_ => {
        Clipboard_.writeText(inviteUrl) -> ignore
        setVisible(_ => true)
      } }
      title=t(."election.show.createInvite.copy") />

      <Portal>
        <Snackbar
          visible
          duration=Snackbar.Duration.value(2000)
          onDismiss={_ => setVisible(_ => false)}>
          { "Copied!" -> React.string }
        </Snackbar>
      </Portal>
    </>
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (inviteUrl, setInviteUrl) = React.useState(_ => "");
  let orgId = State.getAccountExn(state, election.ownerPublicKey)

  React.useEffect0(() => {
    // Create a new account
    let voterId = Account.make()

    let ballot : Ballot.t = {
      electionId,
      previousId: None,
      ciphertext: None,
      pubcred: None,
      electionPublicKey: election.ownerPublicKey,
      voterPublicKey: voterId.hexPublicKey
    }

    let ev = Event_.SignedBallot.create(ballot, orgId)
    dispatch(Event_Add_With_Broadcast(ev))

    let secretKey = Option.getExn(voterId.hexSecretKey)
    
    setInviteUrl(_ => `${URL.base_url}/ballots/${ev.contentHash}#${secretKey}`)
    None
  })

  <>
    <ElectionHeader election section=#inviteLink />

    <View style=Style.viewStyle(
      ~margin=30.0->Style.dp,
      ~borderColor=S.primaryColor,
      ())>
      <Text style=Style.textStyle(
        ~width=600.0->Style.dp, ~alignSelf=#center,
        ())>
        { inviteUrl -> React.string }
      </Text>
    </View>

    <CopyButton inviteUrl />

    <S.Button onPress={_ => {
      Share.share({ message: inviteUrl}) -> ignore }
    } title=t(."election.show.createInvite.share") />
  </>
}
