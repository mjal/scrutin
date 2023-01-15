open ReactNative
@react.component
let make = () => {
  <View></View>
}
/*

open ReactNative; open Helper

@react.component
let make = (~dispatch, ~state: State.state) => {
  let onClick = _ => ()

	<View>
		<Text>{rs("Selectionnez votre candidat")}</Text>
    <View>
      {
        state.election.candidates
        -> Js.Array2.map(candidate =>
          <Text>{rs(candidate.name)}</Text>
        )
        -> React.array
      }
    </View>
		<Button title="Voter" onPress={_ => ()} />
	</View>
}

*/