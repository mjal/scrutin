@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  <>
    <S.Title> {t(. "invitation.title")->React.string} </S.Title>
    <List.Section title="" style=S.marginX>
      {Array.mapWithIndex(state.invitations, (i, invitation) => {
        <Card key=invitation.publicKey>
          <Card.Content>
            <List.Item
              title={t(. "invitation.item.email")}
              description={Option.getWithDefault(invitation.email, "")}
            />
            <List.Item
              title={t(. "invitation.item.phoneNumber")}
              description={Option.getWithDefault(invitation.phoneNumber, "")}
            />
            <List.Item title={"0x" ++ invitation.publicKey} />
          </Card.Content>
          <Card.Actions>
            <Button mode=#contained onPress={_ => dispatch(Invitation_Remove(i))}>
              {t(. "invitation.delete")->React.string}
            </Button>
          </Card.Actions>
        </Card>
      })->React.array}
    </List.Section>
    <Button
      mode=#outlined
      onPress={_ => {
        Invitation.clear()
        dispatch(Reset)
      }}>
      {t(. "invitation.clearAll")->React.string}
    </Button>
    <S.Title> {"-"->React.string} </S.Title>
  </>
}
