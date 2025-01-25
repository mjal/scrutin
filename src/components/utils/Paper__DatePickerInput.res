@module("react-native-paper-dates") @react.component
external make: (
  ~locale: string,
  ~label: string,
  ~value: Js.nullable<Js.Date.t>,
  ~inputMode: [#start],
  ~onChange: Js.nullable<Js.Date.t> => unit,
) => React.element = "DatePickerInput"
