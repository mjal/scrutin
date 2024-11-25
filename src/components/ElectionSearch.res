module Item = {
  @react.component
  let make = (~id, ~election: Election.t) => {
    let (_state, dispatch) = StateContext.use()

    let electionParams = Belenios.Election.parse(election.params)
    let name = electionParams.name == "" ? "Unnamed" : electionParams.name

    <Card style={S.marginY(8.0)}>
      <Card.Content>
        <List.Section title="">
          <List.Item
            onPress={_ => dispatch(Navigate(list{"elections", id}))}
            title=name
            description=electionParams.description
          />
        </List.Section>
      </Card.Content>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, _dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (query, setQuery) = React.useState(_ => "")
  let onSearch = _ => ()

  <>
    <Header title={t(. "search.header.title")} />
    <S.Row style={Style.viewStyle(~marginHorizontal=Style.dp(20.0), ())}>
      <S.Col style={Style.viewStyle(~flexGrow=8.0, ())}>
        <S.TextInput
          label="Search something..."
          testID="election-search"
          value=query
          onChangeText={text => setQuery(_ => text)}
        />
      </S.Col>
      <S.Col>
        <Button onPress=onSearch>
          <SIcon.ButtonSearch />
        </Button>
      </S.Col>
    </S.Row>
    {state.elections
    ->Map.String.toArray
    ->Array.keep(((id, _election)) => {
      Map.String.get(state.electionLatestIds, id)->Option.isNone
    })
    ->Array.keep(((_, election)) => {
      let name = Js.String.toLowerCase(Election.name(election))
      let question = Js.String.toLowerCase(Election.description(election))

      Js.String.indexOf(Js.String.toLowerCase(query), name) != -1 ||
        Js.String.indexOf(Js.String.toLowerCase(query), question) != -1
    })
    ->Array.map(((id, election)) => {
      <Item id election key=id />
    })
    ->React.array}
  </>
}
