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
  let { t } = ReactI18next.useTranslation()

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

    <S.Section title=t(."election.new.choiceList.choices") />

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

  </View>
}
