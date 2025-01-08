module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item
      title=name
      style={Style.viewStyle(~padding=20.0->Style.dp, ~paddingLeft=40.0->Style.dp, ())}
      left={_ => <List.Icon icon={Icon.name(iconName)} />}
      onPress={_ => onSelect()}
    />
  }
}

module Booth = {
  @react.component
  let make = (~electionData: ElectionData.t, ~electionId, ~name) => {
    let election = electionData.setup.election
    let _ = electionId
    let (_state, dispatch) = StateContext.use()
    //let {t} = ReactI18next.useTranslation()
    let (choice, setChoice) = React.useState(_ => None)

    <>
      {Array.mapWithIndex(election.questions, (j, question) => {
        <View style=S.questionBox key={Int.toString(j)}>
          <S.Section title=question.question />
          {Array.mapWithIndex(question.answers, (i, name) => {
            let selected = choice == Some(i)
            <Choice
              name selected key={Int.toString(i)} onSelect={_ => setChoice(_ => Some(i))}
            />
          })->React.array}
        </View>
      })->React.array}

      <S.Button
        title="Voter"
        onPress={_ => {
          let priv = Credential.generatePriv()
          let { hPublicCredential } = Credential.derive(election.uuid, priv)
          let setup: Setup.t = {
            election,
            trustees: [], // FIX:
            credentials: [hPublicCredential],
          }
          let choices = Array.mapWithIndex(election.questions, (_j, question) => {
            Array.mapWithIndex(question.answers, (i, _name) => {
              switch choice {
              | None => 0
              | Some(n) => (i == n) ? 1 : 0
              }
            })
          })
          let ballot = Ballot.generate(
            setup,
            priv,
            choices
          ) // FIX: overall_proof
          dispatch(StateMsg.UploadBallot(name, election, ballot))
        }}
        disabled=(name == "")
      />
    </>
  }
}

//let getSecret = () => {
//  if ReactNative.Platform.os == #web {
//    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
//    if String.length(url.hash) > 12 {
//      Some(url.hash)
//    } else {
//      None
//    }
//  } else {
//    None
//  }
//}

@react.component
let make = (~electionData: ElectionData.t, ~electionId) => {
  let (_state, _dispatch) = StateContext.use()
  //let oSecret = getSecret()
  let (name, setName) = React.useState(_ => "")
  let election = electionData.setup.election

  <>
    <ElectionHeader election />

    <S.TextInput placeholder="Entrez votre nom"
      value=name
      onChangeText={text => setName(_ => text)}
    />

    <Booth electionData electionId name />

    //{ switch oSecret {
    //| None =>
    //  <Text style={S.flatten([S.title, Style.viewStyle(~margin=30.0->Style.dp, ())])}>
    //    {"Vous n'avez pas de clés de vote"->React.string}
    //  </Text>
    //| Some(secret) =>
    //  let account = Account.make2(~secret)
    //  // NOTE: Should we save the account for later ?
    //  //dispatch(StateMsg.Account_Add(account))
    //  // TODO: Check before if account doesn't yet exist ?

    //  let oBallot = Array.getBy(state.ballots, (ballot) => {
    //    ballot.electionId == electionId && ballot.voterId == account.userId
    //  })

    //  { switch oBallot {
    //  | None => <Booth election electionId account />
    //  | Some(_ballot) => <BoothAfterVote electionId />
    //  } }
    //}}
  </>
}
