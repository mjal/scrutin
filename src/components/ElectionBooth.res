open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (privateCred, setPrivateCred) = React.useState(_ => None)
  let (tmpToken, setTmpToken) = React.useState(_ => None)
  let (choice : choice_t, setChoice) = React.useState(_ => ElectionBooth_ChoiceSelect.Blank)
  let (showModal, setshowModal) = React.useState(_ => false)
  let (visibleError, setVisibleError) = React.useState(_ => false)
  let (hasVoted, setHasVoted) = React.useState(_ => false)
  let (changeVote, setChangeVote) = React.useState(_ => false)

  let electionPublicCreds : array<string> = state.election.creds -> Option.map(Belenios.Credentials.parse) -> Option.getWithDefault([])

  let isValidPrivateCred = (token: Token.t) => {
    Array.some(electionPublicCreds, (electionPublicCred) => {
      electionPublicCred == token.public
    })
  }

	let addToken = _ => {
    switch tmpToken {
    | None => ()
    | Some(tmpToken) => {
      try {
        let token : Token.t = { public: Belenios.Credentials.derive(~uuid=Option.getExn(state.election.uuid), ~private_credential=tmpToken), private_: tmpToken}
        if isValidPrivateCred(token) {
          setPrivateCred(_ => Some(token.private_))
          setshowModal(_ => false)
        } else {
          setVisibleError(_ => true)
        }
      } catch {
      | _ => setVisibleError(_ => true)
      }
    }}
	}


  // TODO: React.useEffect0
  React.useEffect(() => {
    let storedToken = Array.getBy(state.tokens, isValidPrivateCred)// -> Option.map((token) => token.private_)
    switch storedToken {
    | None => ()
    | Some(storedToken) => {
      if Option.isNone(privateCred) { setPrivateCred(_ => Some(storedToken.private_)) }
    }}

    Js.log("privateCred")
    Js.log(privateCred)
    Js.log(URL.currentHash())

    let hash = URL.currentHash() -> Js.String.sliceToEnd(~from=1)
    switch hash {
    | "" => ()
    | _ => {
      switch state.election.uuid {
      | None => ()
      | Some(uuid) =>
        let publicCred = Belenios.Credentials.derive(~uuid=uuid, ~private_credential=hash)
        Store.Token.add({public: publicCred, private_: hash})
        if Option.isNone(privateCred) { setPrivateCred(_ => Some(hash)) }
      }
    }}

    None
  })

  React.useEffect(() => {
    switch privateCred {
      | Some(privateCred) =>
      let publicCred = Belenios.Credentials.derive(~uuid=Option.getExn(state.election.uuid), ~private_credential=privateCred)
      if Array.some(state.election.ballots, (b) => { b.public_credential == publicCred && Option.getWithDefault(b.ciphertext, "") != ""}) {
        setHasVoted(_ => true)
      }
      | None => ()
    }

    None
  })

  let vote = _ => {
    let selectionArray =
      Array.length(state.election.choices)
      -> Array.make(0)
      -> Array.mapWithIndex((i, _) => choice == Choice(i) ? 1 : 0)
    dispatch(Ballot_Create_Start(Option.getExn(privateCred), selectionArray))

    setHasVoted(_ => true)
    setChangeVote(_ => false)
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
        {if (hasVoted && !changeVote) {
          <>
            <Title style=StyleSheet.flatten([X.styles["title"],X.styles["green"]])>
              { "Vous avez voté" -> React.string }
            </Title>
            <Button mode=#contained onPress={_ => setChangeVote(_ => true)}>
              {"Changer mon vote" -> React.string}
            </Button>
          </>
        } else {
          <>
            { if Option.isSome(privateCred) {
            <>
              <Title style=StyleSheet.flatten([X.styles["title"],X.styles["green"]])>
                { "Vous avez un droit de vote pour cette election" -> React.string }
              </Title>
              <Divider />
              <ElectionBooth_ChoiceSelect currentChoice=choice onChoiceChange={choice => setChoice(_ => choice)} />
              <Divider />
              <Button mode=#contained onPress=vote>
                {"Voter" -> React.string}
              </Button>
            </>
            } else {
            <>
              <Title style=StyleSheet.flatten([X.styles["title"],X.styles["red"]])>
                { "Vous n'avez pas de droit de vote pour cette election" -> React.string }
              </Title>
              <Button mode=#contained onPress={_ => setshowModal(_ => true)}>
                {"Ajouter un droit de vote" -> React.string}
              </Button>
            </>
          }}
        </>
        }}
      </>
    }}

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])>
          <TextInput
            autoFocus=true
            mode=#flat
            label="Token"
            value=Option.getWithDefault(tmpToken, "")
            onChangeText={text => setTmpToken(_ => Some(Js.String.trim(text)))}
          />
          <X.Row>
            <X.Col>
              <Button onPress={_ => { setTmpToken(_ => None); setshowModal(_ => false)} }>{"Retour"->React.string}</Button>
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