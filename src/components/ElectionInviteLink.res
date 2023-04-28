@react.component
let make = (~election: Election.t, ~electionId) => {
  let _ = electionId // TODO: remove this param
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()
  let (inviteUrl, setInviteUrl) = React.useState(_ => "")
  let admin = state->State.getElectionAdmin(election)

  React.useEffect0(() => {
    let voter = Account.make()
    let invitation: Invitation.t = { userId: voter.userId, email: None, phoneNumber: None }
    dispatch(Invitation_Add(invitation))

    let ev = Event_.ElectionVoter.create({
      electionId,
      voterId: voter.userId
    }, admin)
    dispatch(Event_Add_With_Broadcast(ev))

    setInviteUrl(_ => `${URL.base_url}/elections/${electionId}/booth#${voter.secret}`)
    None
  })

  <>
    <ElectionHeader election section=#inviteLink />
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <S.TextInput onChangeText={_ => ()} value=inviteUrl testID="input-invite-link" />
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
