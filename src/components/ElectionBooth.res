open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (token, setToken) = React.useState(_ => "") // TODO: Rename privateCred
  let (choice : choice_t, setChoice) = React.useState(_ => ElectionBooth_ChoiceSelect.Blank)

  // TODO: React.useEffect0
  React.useEffect(() => {
    // Get from storage
    let electionPublicCreds : array<string> = state.election.creds -> Option.map(Belenios.Credentials.parse) -> Option.getWithDefault([])
    let privateCred = Array.getBy(state.tokens, (token) => {
      Array.some(electionPublicCreds, (electionPublicCred) => {
        electionPublicCred == token.public
      })
    }) -> Option.map((token) => token.private_) -> Option.getWithDefault("")

    if token == "" && privateCred != "" {
      setToken(_ => privateCred)
    }

    // Get from URL
    let hash = URL.currentHash() -> Js.String.sliceToEnd(~from=1)
    if hash != "" {
      let privateCred = hash
      switch privateCred {
      | "" => ()
      | privateCred => {
        let publicCred = Belenios.Credentials.derive(~uuid=Option.getExn(state.election.uuid), ~private_credential=privateCred)
        Store.Token.add({public: publicCred, private_: privateCred})
        if token == "" {
          setToken(_ => privateCred)
        }
      }
      }
    }

    None
  })

  let vote = _ => {
    let selectionArray =
      Array.length(state.election.choices)
      -> Array.make(0)
      -> Array.mapWithIndex((i, _) => choice == Choice(i) ? 1 : 0)

    dispatch(Ballot_Create(token, selectionArray))
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