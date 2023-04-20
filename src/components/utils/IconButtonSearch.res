@module("./IconButtonSearch.svg") external source: Image.Source.t = "default"

let style = {
  open Style
  viewStyle(~alignSelf=#center, ~width=46.0->dp, ~height=46.0->dp, ())
}

@react.component
let make = () => {
  <Image source style />
}
