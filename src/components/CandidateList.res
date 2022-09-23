open Helper
open ReactNative;
open Paper;

let styles = {
  open Style
  StyleSheet.create({
    "header": textStyle(
      ~fontSize=30.,
    ()),
  })
}

@react.component
let make = (~dispatch: Action.t => (), ~state: State.state) => {
	let (name, setName) = React.useState(_ => "")

  let onPress = _ => {
    dispatch(Action.AddCandidate(name))
    setName(_ => "")
  }

	<View>
    <List.Section title="Candidats">
      {
        state.election.candidates
        -> Js.Array2.map(candidate =>
          <Candidate key={candidate.name} name={candidate.name} dispatch={dispatch} />)
        -> React.array
      }
    </List.Section>
    <View>
		  <TextInput mode=#flat value={name} onChangeText={txt => setName(_ => txt)} />
		  <Button onPress>{rs("Ajouter")}</Button>
    </View>
	</View>
}
