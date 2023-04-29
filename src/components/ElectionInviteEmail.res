@react.component
let make = (~election: Election.t, ~electionId) => {
  //let { t } = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()
  let (emails, setEmails) = React.useState(_ => ["", ""])
  let admin = state->State.getElectionAdminExn(election)
  let (sendInvite, setSendInvite) = React.useState(_ => true)

  let onSubmit = _ => {
    emails
    ->Array.keep(email => email != "")
    ->Array.forEach(email => {

      let data = {
        let dict = Js.Dict.empty()
        Js.Dict.set(dict, "email", Js.Json.string(email))
        Js.Dict.set(dict, "electionId", Js.Json.string(electionId))
        Js.Dict.set(dict, "sendInvite", Js.Json.boolean(sendInvite))
        Js.Json.object_(dict)
      }

      X.post(`${URL.server_auth_email}/users`, data)
      ->Promise.then(Webapi.Fetch.Response.json)
      ->Promise.then(json => {
        switch Js.Json.classify(json) {
        | Js.Json.JSONObject(value) =>
          let optionalManagerId = value
          ->Js.Dict.get("managerId")
          ->Option.flatMap(Js.Json.decodeString)
          Promise.resolve(optionalManagerId)
        | _ => failwith("Expected an object")
        }
      })
      ->Promise.thenResolve((optionalManagerId) => {
        switch (optionalManagerId) {
        | Some(managerId) =>
          let invitation: Invitation.t = {
            userId: managerId,
            email: Some(email),
            phoneNumber: None
          }
          dispatch(Invitation_Add(invitation))
          let ev = Event_.ElectionVoter.create({
            electionId,
            voterId: managerId,
          }, admin)
          dispatch(Event_Add_With_Broadcast(ev))
          dispatch(Navigate(list{"elections", electionId}))
        | None => Js.log("No managerId found...")
        }
      })->ignore
    })

  }

  let onRemove = i => {
    setEmails(Array.keepWithIndex(_, (_, index) => index != i))
  }

  let onUpdate = (i, newEmail) => {
    setEmails(emails =>
      Array.mapWithIndex(emails, (index, oldEmail) => {
        index == i ? newEmail : oldEmail
      })
    )
  }

  <>
    <ElectionHeader election section=#inviteMail />
    {Array.mapWithIndex(emails, (i, email) => {
      <ElectionInviteEmailItem
        email
        index={i + 1}
        key={Int.toString(i)}
        onRemove={_ => onRemove(i)}
        onUpdate={email => onUpdate(i, email)}
      />
    })->React.array}
    <S.Button
      style={Style.viewStyle(~width=100.0->Style.dp, ())}
      title="+"
      onPress={_ => setEmails(emails => Array.concat(emails, [""]))}
    />
    <List.Item
      title="Envoyer une invitation"
      description="Tous les participants recevront un email"
      onPress={_ => setSendInvite(b => !b)}
      right={_ => <Switch value=sendInvite />}
    />
    <S.Button onPress=onSubmit title="Inviter" />
  </>
}
