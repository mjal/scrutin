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

module AddModal = {
  @react.component
  let make = (~showModal, ~setShowModal, ~setVoters) => {
	  let (email, setEmail) = React.useState(_ => "")

    let onSubmit = _ => {
      setVoters(voters => Array.concat(voters, [email]))
	  	setEmail(_ => "")
      setShowModal(_ => false)
    }

    <Modal visible=showModal onDismiss={_ => setShowModal(_ => false)}>
      <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="voter-modal">
        <TextInput
          mode=#flat
          label="Email du participant"
          testID="voter-email"
          autoFocus=true
          value=email
          onChangeText={text => setEmail(_ => text)}
          onSubmitEditing=onSubmit
        />
        <X.Row>
          <X.Col>
            <Button onPress={_ => {
              setEmail(_ => "");
              setShowModal(_ => false)}
            }>{"Retour"->React.string}</Button>
          </X.Col>
          <X.Col>
            <Button mode=#contained onPress=onSubmit>{"Ajouter"->React.string}</Button>
          </X.Col>
        </X.Row>
      </View>
    </Modal>
  }
}

@react.component
let make = (~voters, ~setVoters) => {
  let (showModal, setShowModal) = React.useState(_ => false)
  let (visibleError, setVisibleError) = React.useState(_ => false)

  let onRemove = i => {
    setVoters(voters =>
      Array.keepWithIndex(voters, (_, index) => index != i)
    )
  }

  let header = {
    <X.Row>
      <X.Col>
        <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
      </X.Col>
      <X.Col><Text>{React.string("")}</Text></X.Col>
      <X.Col>
        <Button
          mode=#contained
          onPress={_ => setShowModal(_ => true)}
        >
          {"Ajouter" -> React.string}
        </Button>
      </X.Col>
    </X.Row>
  }

	<View testID="voter-list">

    { header }

    <View>
      {
        voters
        -> Array.mapWithIndex((i, voter) => {
          <Item name=voter key=Int.toString(i)
            onRemove={_ => onRemove(i)} />
        })
        -> React.array
      }
    </View>

    <HelperText _type=#error visible={ Array.length(voters) < 1} style=X.styles["center"]>
      {"Il faut au moins 1 votant !"->React.string}
    </HelperText>

    <Portal>
      <AddModal showModal setShowModal setVoters />
      <Snackbar
        visible={visibleError}
        onDismiss={_ => setVisibleError(_ => false)}
      >
        {"Invalid email" -> React.string}
      </Snackbar>
    </Portal>
  </View>
}
