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
  let (showModal, setshowModal) = React.useState(_ => false)
  let { t } = ReactI18next.useTranslation()

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
    <View>
      { Array.mapWithIndex(choices, (i, name) => {
        <Item
          name
          key=Int.toString(i)
          onRemove={_ => onRemove(i)}
        />
      }) -> React.array }
    </View>

    <Button
      style=Style.viewStyle(
        ~alignSelf=#center,
        ~width=50.0->Style.dp,
      ())
      mode=#contained
      onPress={_ => setshowModal(_ => true)}
    >
      <Text
        style=Style.textStyle(
          ~fontSize=30.0,
          ~color=Color.white,
        ())
      >
        { "+" -> React.string }
      </Text>
    </Button>

    <HelperText
      _type=#error
      visible={ Array.length(choices) < 2}
      style=X.styles["center"]>
      { t(."election.new.choiceList.error.atLeastTwoChoices") -> React.string }
    </HelperText>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]]) testID="choice-modal">
          <TextInput
            mode=#flat
            label=t(."election.new.choiceList.modal.choiceName")
            testID="choice-name"
            autoFocus=true
            value=name
            onChangeText={text => setName(_ => text)}
            onSubmitEditing=onSubmit
          />
          <X.Row>
            <X.Col>
              <Button
                onPress={_ => { setName(_ => ""); setshowModal(_ => false)} }>
                { t(."election.new.choiceList.modal.back") -> React.string }
              </Button>
            </X.Col>
            <X.Col>
              <Button mode=#contained onPress=onSubmit>
                { t(."election.new.choiceList.modal.add") -> React.string }
              </Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
    </Portal>
  </View>
}
