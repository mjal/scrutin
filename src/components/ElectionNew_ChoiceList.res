open ReactNative;
open! Paper;

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
	let (name, setName) = React.useState(_ => "")
  let (showModal, setshowModal) = React.useState(_ => false);

	let addChoice = _ => {
		dispatch(Election_AddChoice(name))
		setName(_ => "")
	}

  let onSubmit = _ => {
    addChoice();
    setshowModal(_ => false)
  }

  <View testID="choice-list">
    <X.Row>
      <X.Col>
        <Text style=X.styles["title"]>{"Choix" -> React.string}</Text>
      </X.Col>
      <X.Col><Text>{React.string("")}</Text></X.Col>
      <X.Col>
        <Button
          mode=#contained
          onPress={_ => setshowModal(_ => true)}
        >
          {"Nouveau" -> React.string}
        </Button>
      </X.Col>
    </X.Row>

    <View>
      {
        state.election.choices
        -> Array.mapWithIndex((i, choice) => {
          <ElectionNew_ChoiceItem index=i choice key=Int.toString(i) />
        })
        -> React.array
      }
    </View>

    <HelperText _type=#error visible={ Array.length(state.election.choices) < 2} style=X.styles["center"]>
      {"Il faut au moins 2 choix !"->React.string}
    </HelperText>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])>
          <TextInput
            mode=#flat
            label="Nom du choix"
            testID="choice-name"
            value=name
            onChangeText={text => setName(_ => text)}
            onSubmitEditing=onSubmit
          />
          <X.Row>
            <X.Col>
              <Button onPress={_ => { setName(_ => ""); setshowModal(_ => false)} }>{"Retour"->React.string}</Button>
            </X.Col>
            <X.Col>
              <Button mode=#contained onPress=onSubmit>{"Ajouter"->React.string}</Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
    </Portal>
  </View>
}