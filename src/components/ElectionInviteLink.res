@react.component
let make = (~election: Election.t, ~electionId) => {
  let _ = electionId // TODO: remove this param
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()
  let (inviteUrl, setInviteUrl) = React.useState(_ => "")
  let admin = state->State.getElectionAdmin(election)

  React.useEffect0(() => {
    let voterAccount = Account.make()
    let invitation: Invitation.t = { userId: voterAccount.userId }
    dispatch(Invitation_Add(invitation))

    let election = {...election,
      voterIds: Array.concat(election.voterIds, [voterAccount.userId])
    }
    let ev = Event_.SignedElection.update(election, admin)
    dispatch(Event_Add_With_Broadcast(ev))

    let secretKey = voterAccount.secret
    setInviteUrl(_ => `${URL.base_url}/elections/${ev.cid}/booth#${secretKey}`)
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
