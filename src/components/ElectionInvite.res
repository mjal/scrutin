@react.component
let make = (~election:Election.t, ~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <>
    <ElectionHeader election section=#invite />

    // TODO: i18n
    <S.Button title="Invite by email" onPress={_ => {
      dispatch(Navigate(list{"elections", electionId, "invite_email"}))
    }} />

    // TODO: i18n
    <S.Button title="Invite by link" onPress={_ => ()} />
  </>
}
