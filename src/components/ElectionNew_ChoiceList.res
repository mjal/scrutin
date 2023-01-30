open ReactNative;

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()

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
          <ElectionNew_ChoiceItem choice key=choice.name />
        })
        -> React.array
      }
    </View>
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
		    <TextInput value={name} onChangeText={txt => setName(_ => txt)} placeholder="Choice 1" />
      </View>
      <View style=X.styles["col"]>
        //<View style=styles["smallButton"]>
          <Button onPress={_ => addChoice()} title="Ajouter"></Button>
        //</View>
      </View>
    </View>
	</View>
}