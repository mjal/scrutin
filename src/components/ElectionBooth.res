open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()
  let (token, setToken) = React.useState(_ => "")
  let (choice : choice_t, setChoice) = React.useState(_ => ElectionBooth_ChoiceSelect.Blank)

  React.useEffect0(() => {
    let token = URL.currentHash -> Js.String.sliceToEnd(~from=1)
    setToken(_ => token)

    None
  })

  let vote = _ => {
    let selectionArray =
      Array.length(state.election.choices)
      -> Array.make(0)
      -> Array.mapWithIndex((i, _) => choice == Choice(i) ? 1 : 0)

    dispatch(BallotCreate(token, selectionArray))
  }

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    <View style=X.styles["separator"] />
    <ElectionBooth_ChoiceSelect currentChoice=choice onChoiceChange={choice => setChoice(_ => choice)} />
    <TextInput
      mode=#flat
      label="Token"
      value=token
      onChangeText={text => setToken(_ => Js.String.trim(text))}
    />
    <X.Row>
      <X.Col>
        <Button onPress=vote>
          {"Vote" -> React.string}
        </Button>
      </X.Col>
      <X.Col>
        <Button onPress={_ => dispatch(Action.Navigate(Route.ElectionShow(state.election.id)))}>
          {"Admin" -> React.string}
        </Button>
      </X.Col>
    </X.Row>
	</View>
}