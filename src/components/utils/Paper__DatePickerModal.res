@module("react-native-paper-dates") @react.component
external make: (
  ~locale: string,
  ~mode: [#single | #multiple | #range],
  ~visible: bool,
  ~onDismiss: unit => unit,
  ~date: Js.nullable<Js.Date.t>,
  ~onConfirm: unit => unit,
) => React.element = "DatePickerModal"
