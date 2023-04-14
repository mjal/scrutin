@module external source: Image.Source.t = "./Logo.png"

let style = {
  open Style
  viewStyle(
    ~alignSelf=#center,
    ~width=360.0->dp,
    ~height=139.0->dp,
  ())
}

@react.component
let make = () => {
  <Image source style />
}
