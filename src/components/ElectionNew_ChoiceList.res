module Item = {
  @react.component
  let make = (~onRemove, ~name) => {
    <List.Item
      title=name
      left={_ => <List.Icon icon=Icon.name("vote") />}
      onPress={_ => ()}
      right={_ =>
        <Button onPress=onRemove>
          <List.Icon icon=Icon.name("delete") />
        </Button>
      }
    />
  }
}

@react.component
let make = (~choices, ~setChoices) => {
  let (name, setName) = React.useState(_ => "")
  let (showModal, setshowModal) = React.useState(_ => false);

  let onSubmit = _ => {
    setChoices(choices => Array.concat(choices, [name]))
		setName(_ => "")
    setshowModal(_ => false)
  }

  let onRemove = i => {
    setChoices(choices =>
      Array.keepWithIndex(choices, (_name, index) => index != i)
    )
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
          {"Ajouter" -> React.string}
        </Button>
      </X.Col>
    </X.Row>

    <View>
      { Array.mapWithIndex(choices, (i, name) => {
        <Item
          name
          key=Int.toString(i)
          onRemove={_ => onRemove(i)}
        />
      }) -> React.array }
    </View>

    <HelperText _type=#error visible={ Array.length(choices) < 2} style=X.styles["center"]>
      {"Il faut au moins 2 choix !"->React.string}
    </HelperText>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="choice-modal">
          <TextInput
            mode=#flat
            label="Nom du choix"
            testID="choice-name"
            autoFocus=true
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
