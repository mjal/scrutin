@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let (_, globalDispatch) = StateContext.use()
  let election = electionData.setup.election

  let vote = async _ => {
    let name = Option.getWithDefault(state.name, "")
    let choices = Array.mapWithIndex(election.questions, (j, question) => {
      Array.mapWithIndex(question.answers, (i, _name) => {
        switch Array.getExn(Option.getExn(state.choices), j) {
            | None => 0
            | Some(n) => (i == n) ? 1 : 0
        }
      })
    })

    let ballot = switch state.priv {
    | Some(priv) =>
      Ballot.generate(
        electionData.setup,
        priv,
        choices
      )
    | None =>
      let priv = Credential.generatePriv()
      let { pub } = Credential.derive(election.uuid, priv)
      let setup = {
        ...electionData.setup,
        credentials: Array.concat(electionData.setup.credentials, [pub])
      }
      Ballot.generate(
        setup,
        priv,
        choices
      )
    }

    let obj: Js.Json.t = Js.Json.object_(Js.Dict.fromArray([
      ("name", Js.Json.string(name)),
      ("ballot", Ballot.toJSON(ballot)),
      ("election_uuid", Js.Json.string(election.uuid))
    ]))

    let _response = await X.post(`${URL.bbs_url}/${election.uuid}/ballots`, obj)

    globalDispatch(Navigate(list{"elections", election.uuid, "avote"}))
    //setState(_ => {
    //  ...state,
    //  step: Step5
    //})
  }

  <>
    <Header title="Voter" />

    {
      open Style
      let viewStyle = viewStyle(~alignSelf=#center, ~margin=42.0->dp, ())
      let textStyle = textStyle(~fontSize=120.0, ())
      <View style=viewStyle>
        <Text style=textStyle>
          { "🗳️" -> React.string }
        </Text>
      </View>
    }

    <Title style=Style.textStyle(~alignSelf=#center, ~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Êtes-vous sûr·e ?" -> React.string }
    </Title>

    <S.Button
      title="Valider et envoyer"
      onPress={_ => {
        vote() -> ignore
      }}
    />
  </>
}

