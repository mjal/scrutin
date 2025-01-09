type action = Reset | SetName(string)

type state = {
  name: option<string>
}

let reducer = (_state, action) => {
  switch action {
  | Reset => { name: None }
  | SetName(name) => { name: Some(name) }
  }
}

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

@react.component
let make = (~electionData: ElectionData.t) => {
  let (_, globalDispatch) = StateContext.use()
  let (state, dispatch) = React.useReducer(reducer, {name: None})
  let (name, setName) = React.useState(_ => "")
  let (choice, setChoice) = React.useState(_ => None)
  let election = electionData.setup.election

  let vote = _ => {
    let priv = Credential.generatePriv()
    let { hPublicCredential } = Credential.derive(election.uuid, priv)
    let setup = {
      ...electionData.setup,
      credentials: Array.concat(electionData.setup.credentials, [hPublicCredential])
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
    ) // FIX: overall_proof ?
    globalDispatch(StateMsg.UploadBallot(name, election, ballot))
  }

  switch state.name {
  | None =>
    <>
      <ElectionHeader election />

      <S.Title>
        { "Entrez votre nom" -> React.string }
      </S.Title>

      <S.TextInput placeholder="Votre nom"
        value=name
        onChangeText={text => setName(_ => text)}
      />

      <S.Button
        title="Voter"
        onPress={_ => dispatch(SetName(name))}
      />
    </>
  | Some(name) =>
    <>
      <ElectionHeader election />

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
      <View style={Style.viewStyle(~marginTop=-30.0->Style.dp, ())}>
        <View style={Style.viewStyle(~position=#absolute, ~right=30.0->Style.dp, ())}>
          <Text
            style={Style.textStyle(
              ~width=switch ReactNative.Platform.os {
              | #web => 80.0->Style.dp
              | _ => 120.0->Style.dp
              },
              ~backgroundColor=S.primaryColor,
              ~color=Color.white,
              ~paddingBottom=5.0->Style.dp,
              ~paddingLeft=8.0->Style.dp,
              (),
            )}>
            {"Vote privé"->React.string}
          </Text>
        </View>
      </View>

      <S.Button
        title="Voter"
        onPress=vote
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
