@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()
  let (inviteUrl, setInviteUrl) = React.useState(_ => "")
  let orgId = State.getAccountExn(state, election.ownerPublicKey)

  React.useEffect0(() => {
    let voterId = Account.make()
    let invitation: Invitation.t = { publicKey: voterId.hexPublicKey }
    dispatch(Invitation_Add(invitation))

    let ballot = Ballot.new(election, electionId, voterId.hexPublicKey)
    let ev = Event_.SignedBallot.create(ballot, orgId)
    dispatch(Event_Add_With_Broadcast(ev))

    let secretKey = voterId.hexSecretKey
    setInviteUrl(_ => `${URL.base_url}/ballots/${ev.cid}#${secretKey}`)
    None
  })

  <>
    <ElectionHeader election section=#inviteLink />
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <S.TextInput onChangeText={_ => ()} value=inviteUrl />
    </View>
    <CopyButton text=inviteUrl />
    <S.Button
      onPress={_ => {
        Share.share({message: inviteUrl})->ignore
      }}
      title={t(. "election.show.createInvite.share")}
    />
  </>
}
