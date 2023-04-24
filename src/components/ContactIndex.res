@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  <>
    <S.Title> {t(. "contact.title")->React.string} </S.Title>
    <List.Section title="" style=S.marginX>
      {Array.mapWithIndex(state.invitations, (i, contact) => {
        <Card key=contact.publicKey>
          <Card.Content>
            <List.Item
              title={t(. "contact.item.email")}
              description={Option.getWithDefault(contact.email, "")}
            />
            <List.Item
              title={t(. "contact.item.phoneNumber")}
              description={Option.getWithDefault(contact.phoneNumber, "")}
            />
            <List.Item title={"0x" ++ contact.publicKey} />
          </Card.Content>
          <Card.Actions>
            <Button mode=#contained onPress={_ => dispatch(Invitation_Remove(i))}>
              {t(. "contact.delete")->React.string}
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
      {t(. "contact.clearAll")->React.string}
    </Button>
    <S.Title> {"-"->React.string} </S.Title>
  </>
}
