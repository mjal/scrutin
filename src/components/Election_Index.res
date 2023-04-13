module Election = {
  @react.component
  let make = (~id, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()

    let electionParams = Belenios.Election.parse(election.params)
    let name = electionParams.name == "" ? "Unnamed" : electionParams.name

    <Card style=X.styles["margin-y-8"]>
      <Card.Content>
        <List.Section title="">

          <List.Item
            onPress={ _ => dispatch(Navigate(list{"elections", id})) }
            title=name
            description=electionParams.description />

        </List.Section>
      </Card.Content>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let buttonStyle = Style.viewStyle(
    ~paddingVertical=10.0->Style.dp,
    ~marginTop=20.0->Style.dp,
    ~marginBottom=20.0->Style.dp,
    ~width=350.0->Style.dp,
    ~alignSelf=#center,
    ()
  )

  let buttonTextStyle = Style.textStyle(
    ~fontSize=20.0,
    ~color=Color.white,
    ()
  )

  <>
    <Logo />

    <Button style=buttonStyle mode=#contained
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}>
      <Text style=buttonTextStyle>
        { t(."election.home.create") -> React.string }
      </Text>
    </Button>
    { state.cachedElections
      -> Map.String.toArray
      -> Array.keep(((id, _election)) => {
        state.cachedElectionReplacementIds
        -> Map.String.get(id)
        -> Option.isNone
      })
      -> Array.map(((id, election)) => {
        <Election id election key=id />
    }) -> React.array }
  </>
}
