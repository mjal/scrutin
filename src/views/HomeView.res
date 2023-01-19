open ReactNative

@react.component
let make = () => {
  let (_, dispatch) = State.useContextReducer()

  <View>
    <View style=X.styles["separator"] />
    <Button title="Nouvelle election" onPress={_ => dispatch(Navigate(Route.ElectionNew))}/>
    <View style=X.styles["separator"] />
    <Text style=X.styles["title"]>{"Current elections" -> React.string}</Text>
    <ElectionList />
  </View>
}
/*

open Helper
open ReactNative;
open Paper;

let styles = {
  open Style
  StyleSheet.create({
    "divider": viewStyle(
      ~margin=dp(20.),
    ())
  })
}

@react.component
let make = (~state: State.state, ~dispatch: Action.t => unit) => {

  let onPress = _ => {
    state.election
    -> Election.post
    -> Promise.then(res => {
      res
      -> Webapi.Fetch.Response.json
      -> Promise.thenResolve(Election.from_json)
      -> Promise.thenResolve(election => {
        let id = election.id
        RescriptReactRouter.push(j`/election/$id`)
      })
    })
    -> ignore
  }

  <ReactNative.View>

    <Paper.TextInput
      mode=#flat
      label="Nom de l'élection"
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    />
    <Divider style=styles["divider"] />

    <CandidateList state dispatch />
    <Divider style=styles["divider"] />

    <VoterList state dispatch />
    <Divider style=styles["divider"] />

    <Button onPress mode=#contained>{rs("Create Election")}</Button>
  </ReactNative.View>
}
*/