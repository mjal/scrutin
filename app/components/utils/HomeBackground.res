//@module("./HomeBackground.svg") external source: Image.Source.t = "default"
//
//@react.component
//let make = () => {
//  let style = Style.viewStyle(~width=100.0->Style.pct, ~height=868.0->Style.dp, ())
//
//  <Image source style />
//}

@module("./HomeBackgroundJs") @react.component
external make: () => React.element = "default"
