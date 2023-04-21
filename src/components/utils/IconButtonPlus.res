@module("./IconButtonPlus.svg") external source: Image.Source.t = "default"

let defaultStyle = {
  open Style
  viewStyle(~alignSelf=#center, ~width=46.0->dp, ~height=46.0->dp, ())
}

@react.component
let make = (~style=?) => {
  let style = switch style {
  | Some(style) => StyleSheet.flatten([defaultStyle, style])
  | None => defaultStyle
  }
  <Image source style />
}

