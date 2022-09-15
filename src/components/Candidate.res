open ReactNative; open Helper

@react.component
let make = (~name, ~dispatch) => {
  <Text>{name->rs}</Text>
}
