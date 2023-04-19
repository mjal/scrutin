@react.component
let make = (~election:Election.t, ~electionId) => {
  //let { t } = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()
  let (emails, setEmails) = React.useState(_ => ["", ""])
  let orgId = state->State.getAccountExn(election.ownerPublicKey)
  let (sendInvite, setSendInvite) = React.useState(_ => true)

  let onSubmit = _ => {
    Array.forEach(emails, (email) => {
      let voterId = Account.make()

      let contact : Contact.t = {
        hexPublicKey: voterId.hexPublicKey,
        email: Some(email),
        phoneNumber: None
      }

      dispatch(Contact_Add(contact))

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

      switch (sendInvite) {
      | true  => Mailer.send(ev.cid, orgId, voterId, email)
      | false => ()
      }
    })

    dispatch(Navigate(list{"elections", electionId}))
  }

  let onRemove = i => {
    setEmails(Array.keepWithIndex(_, (_, index) => index != i))
  }

  let onUpdate = (i, newEmail) => {
    setEmails(emails =>
      Array.mapWithIndex(emails, (index, oldEmail) => {
        (index == i) ? newEmail : oldEmail
      })
    )
  }

  <>
    <ElectionHeader election section=#inviteMail />

    { Array.mapWithIndex(emails, (i, email) => {
      <ElectionInviteEmailItem email
        index=(i+1) key=Int.toString(i)
        onRemove={_ => onRemove(i)}
        onUpdate={email => onUpdate(i, email)}
      />
    }) -> React.array }

    <S.Button
      style=Style.viewStyle(~width=100.0->Style.dp,())
      title="+"
      onPress={_ => setEmails(emails => Array.concat(emails, [""])) } />

    <List.Item
      title="Envoyer une invitation"
      description="Tous les participants recevront un email"
      onPress={_ => setSendInvite(b => !b)}
      right={_ => <Switch value=sendInvite /> }
    />

    <S.Button onPress=onSubmit title="Inviter" />

    <Button mode=#text onPress={_ =>
      dispatch(Navigate(list{"elections"}))}
    >
      { "Gérer les invitations" -> React.string }
    </Button>
  </>
}
