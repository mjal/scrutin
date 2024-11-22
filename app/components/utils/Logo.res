@module("./Logo.png") external source: Image.Source.t = "default"

let style = {
  open Style
  viewStyle(~alignSelf=#center, ~width=360.0->dp, ~height=139.0->dp, ())
}

@react.component
let make = () => {
  // BUG: Can't use image ?
  //<Image source style />
  <Text>{ "Image" -> React.string }</Text>
}
