@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let _ = (election, electionId)
  <></>
}
//  let (_state, dispatch) = StateContext.use()
//  //let { t } = ReactI18next.useTranslation()
//
//  <>
//    <ElectionHeader election section=#invite />
//    <S.Button
//      title="Invite by email"
//      testID="button-invite-email"
//      onPress={_ => {
//        dispatch(Navigate(list{"elections", electionId, "invite_email"}))
//      }}
//    />
//    //<S.Button
//    //  title="Invite by phone"
//    //  testID="button-invite-phone"
//    //  onPress={_ => {
//    //    dispatch(Navigate(list{"elections", electionId, "invite_phone"}))
//    //  }}
//    ///>
//    <S.Button
//      title="Invite by link"
//      testID="button-invite-link"
//      onPress={_ => dispatch(Navigate(list{"elections", electionId, "invite_link"}))}
//    />
//    <Button mode=#text
//      onPress={_ => dispatch(Navigate(list{"elections", electionId, "invite_manage"}))}>
//      {"Gérer les invitations"->React.string}
//    </Button>
//  </>
//}
