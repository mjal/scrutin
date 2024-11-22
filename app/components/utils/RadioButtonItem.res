@module("react-native-paper") @scope("RadioButton") @react.component
external make: (
  ~value: string,
  ~label: string,
  ~onPress: ReactNative.Event.pressEvent => unit=?,
  ~color: string=?,
  ~status: [#checked | #unchecked]=?,
  ~disabled: bool=?,
  ~testID: string=?
) => React.element = "Item"
