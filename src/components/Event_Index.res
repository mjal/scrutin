module Item = {
  @react.component
  let make = (~event : Event_.t) => {
    let (_state, dispatch) = Context.use()
    let { t } = ReactI18next.useTranslation()

    let description = switch event.type_ {
    | #election => "Election"
    | #ballot   => "Ballot"
    | #tally    => "Tally"
    }

    let onPress = _ => {
      switch event.type_ {
      | #election => dispatch(Navigate(Election_Show(event.contentHash)))
      | #ballot   => dispatch(Navigate(Ballot_Show(event.contentHash)))
      | #tally    =>
        let tally = Event_.SignedTally.unwrap(event)
        dispatch(Navigate(Election_Show(tally.electionId)))
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
