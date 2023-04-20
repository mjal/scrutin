module Item = {
  @react.component
  let make = (~event: Event_.t) => {
    let (_state, dispatch) = StateContext.use()
    let {t} = ReactI18next.useTranslation()

    let description = Event_.event_type_t_to_s(event.type_)

    let onPress = _ => {
      switch event.type_ {
      | #"election.create" => dispatch(Navigate(list{"elections", event.cid}))
      | #"election.update" => dispatch(Navigate(list{"elections", event.cid}))
      | #"ballot.create" => dispatch(Navigate(list{"ballots", event.cid}))
      | #"ballot.update" => dispatch(Navigate(list{"ballots", event.cid}))
      }
    }

    <Card>
      <List.Item key=event.cid title={t(. "events.item.type")} description onPress />
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let clear = _ => {
    Event_.clear()
    dispatch(Reset)
  }

  <List.Section title={t(. "events.title")}>
    {Array.map(state.events, event => <Item event key=event.cid />)->React.array}
    <S.Title> {"-"->React.string} </S.Title>
    <Button mode=#contained onPress=clear> {t(. "events.clear")->React.string} </Button>
  </List.Section>
}
