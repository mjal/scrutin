@react.component
let make = (~onRemove, ~onUpdate, ~email, ~index) => {
  <S.Row style={Style.viewStyle(~marginHorizontal=Style.dp(20.0), ())}>
    <S.Col style={Style.viewStyle(~flexGrow=10.0, ())}>
      <TextInput
        mode=#flat value=email onChangeText=onUpdate
        label={`Email ${index->Int.toString}`} testID={`input-invite-email-${index->Int.toString}`}
      />
    </S.Col>
    <S.Col>
      <Button onPress=onRemove>
        <List.Icon icon={Icon.name("delete")} />
      </Button>
    </S.Col>
  </S.Row>
}
