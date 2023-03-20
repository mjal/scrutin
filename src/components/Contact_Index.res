@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "Contacts" -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.mapWithIndex(state.contacts, (i, contact) => {
      <Card key=contact.hexPublicKey>
        <Card.Content>
          <List.Item title="email"
            description=Option.getWithDefault(contact.email, "") />
          <List.Item title="phoneNumber"
            description=Option.getWithDefault(contact.phoneNumber, "") />
          <List.Item title=("0x" ++ contact.hexPublicKey) />
        </Card.Content>
        <Card.Actions>
          <Button mode=#contained onPress={_ =>
            dispatch(Contact_Remove(i))
          }>
            {"Delete"->React.string}
          </Button>
        </Card.Actions>
      </Card>
    }) -> React.array }
    </List.Section>

    <Button mode=#outlined onPress={_ => {
      Contact.clear()
      dispatch(Reset)
    }}>
      { "Clear contacts" -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>
  </>
}

