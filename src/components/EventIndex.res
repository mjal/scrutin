module Item = {
  @react.component
  let make = (~event: Event_.t) => {
    let (_state, _dispatch) = StateContext.use()
    let {t} = ReactI18next.useTranslation()

    let event_type = Event_.event_type_map
    ->Array.getBy(((variant, _str)) => variant == event.type_)
    ->Option.map(((_,str)) => str)

    let description = switch event_type {
    | Some(event_type) => event_type
    | None => "Unknown type"
    }

    let onPress = _ => ()

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
