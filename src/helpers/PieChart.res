module Datum = {
  type svg_t = {
    fill: string
  }
  type t = {
    value: int,
    key: string,
    svg: svg_t
  }

  let make = (~value, ~key, ~color) => {
    let svg = { fill: color }
    {
      value,
      key,
      svg
    }
  }
}

@module("react-native-svg-charts") @react.component
external make: (
  ~data: array<Datum.t>,
  ~style: ReactNative.Style.t=?,
) => React.element = "PieChart"
