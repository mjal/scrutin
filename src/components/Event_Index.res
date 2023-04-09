module Item = {
  @react.component
  let make = (~event : Event_.t) => {
    let (_state, dispatch) = Context.use()
    let { t } = ReactI18next.useTranslation()

    let description = Event_.event_type_t_to_s(event.type_)

    let onPress = _ => {
      switch event.type_ {
      | #"election.create" => dispatch(Navigate(Election_Show(event.contentHash)))
      | #"election.update" => dispatch(Navigate(Election_Show(event.contentHash)))
      | #"ballot.create" => dispatch(Navigate(Ballot_Show(event.contentHash)))
      | #"ballot.update" => dispatch(Navigate(Ballot_Show(event.contentHash)))
      }
    }

    <Card>
      <List.Item key=event.contentHash title=t(."events.item.type") description onPress />
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let clear = _ => {
    Event_.clear()
    dispatch(Reset)
  }

  <List.Section title=t(."events.title")>

    { Array.map(state.events, (event) =>
      <Item event key=event.contentHash />
    ) -> React.array }

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress=clear>
      { t(."events.clear") -> React.string }
    </Button>
  </List.Section>
}
