open ReactNative;
open! Paper;

let styles = {
  open Style

  StyleSheet.create({
    "modal": textStyle(
      ~padding=10.0->dp,
      ~margin=10.0->dp,
      ~backgroundColor=Color.white,
      ()
    )
  })
}

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()

	let (name, setName) = React.useState(_ => "")

	let addChoice = _ => {
		dispatch(AddChoice(name))
		setName(_ => "")
	}

  let (visible, setVisible) = React.useState(_ => false);

  let showModal = () => setVisible(_ => true);
  let hideModal = () => setVisible(_ => false);

  <>
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Text style=X.styles["title"]>{"Choix" -> React.string}</Text>
      </View>
      <View style=X.styles["col"]>
      </View>
      <View style=X.styles["col"]>
        <Button
          mode=#contained
          onPress={_ => showModal()}
        >
          {"Nouveau" -> React.string}
        </Button>
      </View>
    </View>

    <HelperText _type=#info visible={ Array.length(state.election.choices) <= 2}>
      {"Il faut au moins 2 choix !"->React.string}
    </HelperText>

    <View>
      {
        state.election.choices
        -> Array.mapWithIndex((i, choice) => {
          <ElectionNew_ChoiceItem index=i choice key=Int.toString(i) />
        })
        -> React.array
      }
    </View>

    <Portal>
      <Modal visible={visible} onDismiss={hideModal}>
        <View style=styles["modal"]>
          <TextInput
            mode=#flat
            label="Nom du choix"
            value=name
            onChangeText={text => setName(_ => text)}
          />
          <View style=X.styles["row"]>
            <View style=X.styles["col"]>
              <Button onPress={_ => { setName(_ => ""); hideModal()} }>{"Retour"->React.string}</Button>
          </View>
          <View style=X.styles["col"]>
            <Button mode=#contained onPress={_ => { addChoice(); hideModal()} }>{"Ajouter"->React.string}</Button>
          </View>
          </View>
        </View>
      </Modal>
    </Portal>
  </>
}