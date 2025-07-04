@react.component
let make = (~onRemove, ~onUpdate, ~name, ~index) => {
  <S.Row style={Style.viewStyle(~marginHorizontal=Style.dp(20.0), ())}>
    <S.Col style={Style.viewStyle(~flexGrow=10.0, ())}>
      <S.TextInput
        testID=`choice-${index->Int.toString}`
        placeholder={`Option ${index->Int.toString}...`}
        placeholderTextColor="#bbb"
        value=name
        onChangeText=onUpdate
      />
    </S.Col>
    <S.Col>
      <TouchableOpacity onPress=onRemove>
        <SIcon.ButtonCross />
      </TouchableOpacity>
    </S.Col>
  </S.Row>
}
