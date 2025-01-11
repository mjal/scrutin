// TODO: Monitor the voting request (loading screen?)

@react.component
let make = (~electionData: ElectionData.t, ~state: Election_OpenBooth_State.t, ~dispatch) => {
  let (_, globalDispatch) = StateContext.use()
  let election = electionData.setup.election

  let vote = _ => {
    let name = Option.getExn(state.name)
    let priv = Credential.generatePriv()
    let { hPublicCredential } = Credential.derive(election.uuid, priv)
    let setup = {
      ...electionData.setup,
      credentials: Array.concat(electionData.setup.credentials, [hPublicCredential])
    }
    let choices = Array.mapWithIndex(election.questions, (_j, question) => {
      Array.mapWithIndex(question.answers, (i, _name) => {
        switch state.choice {
          | None => 0
          | Some(n) => (i == n) ? 1 : 0
        }
      })
    })
    let ballot = Ballot.generate(
      setup,
      priv,
      choices
    )
    globalDispatch(StateMsg.UploadBallot(name, election, ballot))
  }

  <>
    <Header title="Voter" />

    <Button icon=Paper.Icon.name("vote")>
      { "" -> React.string }
    </Button>
  
    <Title>
      { "Êtes-vous sûr ?" -> React.string }
    </Title>
  
    <S.Button
      title="Valider et envoyer"
      onPress={_ => {
        vote()
        dispatch(Election_OpenBooth_State.SetStep(Step5))
      }}
    />
  </>
}

