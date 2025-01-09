@react.component
let make = (~electionData: ElectionData.t) => {
  let _ = (electionData)
  <></>
}
//@react.component
//let make = (~election: Election.t, ~electionId) => {
//  //let { t } = ReactI18next.useTranslation()
//  let (state, dispatch) = StateContext.use()
//  let (emails, setEmails) = React.useState(_ => ["", ""])
//  let admin = state->State.getElectionAdminExn(election)
//  let (sendInvite, setSendInvite) = React.useState(_ => true)
//
//  let onSubmit = _ => {
//    emails
//    ->Array.keep(email => email != "")
//    ->Array.forEach(email => {
//      InviteQuery.send(dispatch, admin, "email", email, electionId, sendInvite)
//    })
//  }
//
//  let onRemove = i => {
//    setEmails(Array.keepWithIndex(_, (_, index) => index != i))
//  }
//
//  let onUpdate = (i, newEmail) => {
//    setEmails(emails =>
//      Array.mapWithIndex(emails, (index, oldEmail) => {
//        index == i ? newEmail : oldEmail
//      })
//    )
//  }
//
//  <>
//    <ElectionHeader election section=#inviteMail />
//    {Array.mapWithIndex(emails, (i, email) => {
//      <ElectionInviteEmailItem
//        email
//        index={i + 1}
//        key={Int.toString(i)}
//        onRemove={_ => onRemove(i)}
//        onUpdate={email => onUpdate(i, email)}
//      />
//    })->React.array}
//    <S.Button
//      style={Style.viewStyle(~width=100.0->Style.dp, ())}
//      title="+"
//      onPress={_ => setEmails(emails => Array.concat(emails, [""]))}
//    />
//    <List.Item
//      title="Envoyer une invitation"
//      description="Tous les participants recevront un email"
//      onPress={_ => setSendInvite(b => !b)}
//      right={_ => <Switch value=sendInvite />}
//    />
//    <S.Button onPress=onSubmit title="Inviter" />
//  </>
//}
