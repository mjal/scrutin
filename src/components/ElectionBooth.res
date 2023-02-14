open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (token, setToken) = React.useState(_ => "") // TODO: Rename privateCred
  let (choice : choice_t, setChoice) = React.useState(_ => ElectionBooth_ChoiceSelect.Blank)
  let (showModal, setshowModal) = React.useState(_ => false)
  let (visibleError, setVisibleError) = React.useState(_ => false)

	let addToken = _ => {
    // TODO: Actually hash and verify that the token is valid for that election
    if token != "" { 
      setshowModal(_ => false)
    } else {
      setVisibleError(_ => true)
    }
	}

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
    dispatch(Ballot_Create_Start(token, selectionArray))
  }

  <>
    { if state.voting_in_progress {
      <Title style=X.styles["title"]>
        <Text>{"Voting in progress..." -> React.string}</Text>
        <ActivityIndicator />
      </Title>
    } else {
      <>
        <View style=X.styles["separator"] />
        <ElectionBooth_ChoiceSelect currentChoice=choice onChoiceChange={choice => setChoice(_ => choice)} />
        { if token != "" {
          <>
          <Title style=X.styles["title"]>{ "Vous avez un droit de vote pour cette election" -> React.string }</Title>
          <Divider />
          <Button mode=#contained onPress=vote>
            {"Voter" -> React.string}
          </Button>
          </>
        } else {
          <>
          <Title style=X.styles["title"]>{ "Vous n'avez pas de droit de vote pour cette election" -> React.string }</Title>
          <Button mode=#contained onPress={_ => setshowModal(_ => true)}>
            {"Ajouter" -> React.string}
          </Button>
          </>
        }}
      </>
    }}

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])>
          <TextInput
            mode=#flat
            label="Token"
            value=token
            onChangeText={text => setToken(_ => Js.String.trim(text))}
          />
          <X.Row>
            <X.Col>
              <Button onPress={_ => { setToken(_ => ""); setshowModal(_ => false)} }>{"Retour"->React.string}</Button>
            </X.Col>
            <X.Col>
              <Button mode=#contained onPress=addToken>{"Ajouter"->React.string}</Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
      <Snackbar
        visible={visibleError}
        onDismiss={_ => setVisibleError(_ => false)}
      >
        {"Invalid token" -> React.string}
      </Snackbar>
    </Portal>
	</>
}