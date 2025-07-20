type time_params_t = { hours: Js.nullable<int>, minutes: Js.nullable<int> }
@module("react-native-paper-dates") @react.component
external make: (
  ~locale: string,
  ~visible: bool,
  ~onDismiss: unit => unit,
  ~onConfirm: time_params_t => unit,
  ~hours: Js.nullable<int>,
  ~minutes: Js.nullable<int>,
) => React.element = "TimePickerModal"
