@react.component
let make = (~onRemove, ~onUpdate, ~name, ~index) => {
  <S.Row style=Style.viewStyle(~marginHorizontal=Style.dp(20.0),())>
    <S.Col style=Style.viewStyle(~flexGrow=10.0,())>
      <TextInput
        mode=#flat
        label=`Choice ${index->Int.toString}`
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
