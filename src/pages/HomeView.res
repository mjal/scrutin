open ReactNative
open Helper

let styles = {
  open Style
  StyleSheet.create({
    "container": viewStyle(
      ~maxHeight=600.->dp,
      ~width=80.->pct,
      //~justifyContent=#flexStart,
      ~alignItems=#center,
      ~margin=auto,
      (),
    ),
    "cornerThing": viewStyle(
      ~position=#absolute,
      ~top=100.->dp,
      ~right=-20.->dp,
      ~transform=[rotate(~rotate=4.->deg)],
      (),
    ),
    "title": textStyle(
      ~textAlign=#center,
      ~fontSize=20.0,
      ()
    ),
    "subtitle": textStyle(
      ~textAlign=#center,
      ()
    ),
  })
}

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Text style=styles["title"]>{"Scrutin.app"->rs}</Text>
    <Text style=styles["subtitle"]>{"Enjoy end-to-end encrypted elections"->rs}</Text>
    <Button title="Click me" onPress={_ => ()}/>
    <Text>{state.election.name->rs}</Text>
    <TextInput
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </TextInput>
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