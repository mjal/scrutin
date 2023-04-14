@module external source: Image.Source.t = "./HomeBackground.svg"

@react.component
let make = () => {
  let style = Style.viewStyle(
    ~width=100.0->Style.pct,
    ~height=868.0->Style.dp,
    ()
  )

  <Image source style />
}
