@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <>
    <X.Title>{ t(."contact.title") -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.mapWithIndex(state.contacts, (i, contact) => {
      <Card key=contact.hexPublicKey>
        <Card.Content>
          <List.Item title=t(."contact.item.email")
            description=Option.getWithDefault(contact.email, "") />
          <List.Item title=t(."contact.item.phoneNumber")
            description=Option.getWithDefault(contact.phoneNumber, "") />
          <List.Item title=("0x" ++ contact.hexPublicKey) />
        </Card.Content>
        <Card.Actions>
          <Button mode=#contained onPress={_ =>
            dispatch(Contact_Remove(i))
          }>
            {t(."contact.delete") -> React.string}
          </Button>
        </Card.Actions>
      </Card>
    }) -> React.array }
    </List.Section>

    <Button mode=#outlined onPress={_ => {
      Contact.clear()
      dispatch(Reset)
    }}>
      { t(."contact.clearAll") -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>
  </>
}

