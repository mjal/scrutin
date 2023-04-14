module Item = {
  @react.component
  let make = (~onRemove, ~onUpdate, ~name, ~index) => {
    <S.Row style=Style.viewStyle(~marginHorizontal=Style.dp(20.0),())>
      <S.Col style=Style.viewStyle(~flexGrow=10.0,())>
        <TextInput
          mode=#flat
          label=j`Choice $index`
		    	value=name
          onChangeText=onUpdate
        />
      </S.Col>
      <S.Col>
        <Button onPress=onRemove>
          <List.Icon icon=Icon.name("delete") />
        </Button>
      </S.Col>
    </S.Row>
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

  let onUpdate = (i, newName) => {
    setChoices(choices =>
      Array.mapWithIndex(choices, (index, oldName) => {
        if (index == i) {
          newName
        } else {
          oldName
        }
      })
    )
  }

  <View testID="choice-list">

    <Title style=S.section>
      { t(."election.new.choiceList.choices") -> React.string }
    </Title>

    <View>
      { Array.mapWithIndex(choices, (i, name) => {
        <Item
          name
          index=(i+1)
          key=Int.toString(i)
          onRemove={_ => onRemove(i)}
          onUpdate={name => onUpdate(i, name)}
        />
      }) -> React.array }
    </View>

    <S.Button
      style=Style.viewStyle(~width=100.0->Style.dp,())
      title="+"
      onPress={_ => setChoices(choices => Array.concat(choices, [""])) } />

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=S.flatten([S.modal, S.layout]) testID="choice-modal">
          <TextInput
            mode=#flat
            label=t(."election.new.choiceList.modal.choiceName")
            testID="choice-name"
            autoFocus=true
            value=name
            onChangeText={text => setName(_ => text)}
            onSubmitEditing=onSubmit
          />
          <S.Row>
            <S.Col>
              <Button
                onPress={_ => { setName(_ => ""); setshowModal(_ => false)} }>
                { t(."election.new.choiceList.modal.back") -> React.string }
              </Button>
            </S.Col>
            <S.Col>
              <Button mode=#contained onPress=onSubmit>
                { t(."election.new.choiceList.modal.add") -> React.string }
              </Button>
            </S.Col>
          </S.Row>
        </View>
      </Modal>
    </Portal>
  </View>
}
