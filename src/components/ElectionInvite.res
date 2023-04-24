@react.component
let make = (~election: Election.t, ~electionId) => {
  let (_state, dispatch) = StateContext.use()
  //let { t } = ReactI18next.useTranslation()

  <>
    <ElectionHeader election section=#invite />
    <S.Button
      title="Invite by email"
      onPress={_ => {
        dispatch(Navigate(list{"elections", electionId, "invite_email"}))
      }}
    />
    <S.Button
      title="Invite by link"
      onPress={_ => dispatch(Navigate(list{"elections", electionId, "invite_link"}))}
    />
    <Button mode=#text onPress={_ => dispatch(Navigate(list{"elections"}))}>
      {"Gérer les invitations"->React.string}
    </Button>
  </>
}
