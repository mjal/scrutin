open ReactNative;

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

	let (name, setName) = React.useState(_ => "")

	let addChoice = _ => {
		dispatch(AddChoice(name))
		setName(_ => "")
	}

	<View>
    <View>
      {
        state.election.choices
        -> Js.Array2.map(choice => {
          <ChoiceItem choice key=choice.name />
        })
        -> React.array
      }
    </View>
    <View style=shared_styles["row"]>
      <View style=shared_styles["col"]>
		    <TextInput value={name} onChangeText={txt => setName(_ => txt)} placeholder="Choice 1" />
      </View>
      <View style=shared_styles["col"]>
        //<View style=styles["smallButton"]>
          <Button onPress={_ => addChoice()} title="Ajouter"></Button>
        //</View>
      </View>
    </View>
	</View>
}

/*
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
*/