module SimpleTitle = {
  @react.component
  let make = (~text) => {
    <Text
      style=Style.textStyle(
        ~color=Color.black,
        ~fontSize=18.0,
        ~fontWeight=Style.FontWeight._700,
        (),
      )
    >
      { text->React.string }
    </Text>
  }
}

module SimpleContent = {
  @react.component
  let make = (~text) => {
    <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
      { text->React.string }
    </Text>
  }
}

type option_t = { value: string, title: React.element, content: React.element }
@react.component
let make = (~value, ~onValueChange, ~options) => {
  <RadioButton.Group
    value
    onValueChange
  >
    { Array.map(options, o => {
      <TouchableOpacity
        style=Style.viewStyle(~marginBottom=16.0->Style.dp, ())
        onPress={_ => { let _ = onValueChange(o.value); ()}}
        key=o.value
      >
        <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
          <RadioButton value=o.value status=(if value == o.value { #checked } else { #unchecked }) />
          { o.title }
        </View>
        { o.content }
      </TouchableOpacity>
    }) -> React.array }
  </RadioButton.Group>
}
