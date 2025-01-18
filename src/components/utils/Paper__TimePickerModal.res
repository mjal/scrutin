@module("react-native-paper-dates") @react.component
external make: (
  ~locale: string,
  ~visible: bool,
  ~onDismiss: unit => unit,
  ~onConfirm: unit => unit,
  ~hours: Js.nullable<int>,
  ~minutes: Js.nullable<int>,
) => React.element = "TimePickerModal"
