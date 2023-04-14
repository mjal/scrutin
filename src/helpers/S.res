open Style

let title = textStyle(
  ~textAlign=#center,
  ~fontSize=20.0,
  ~color=Color.black,
  ()
)

module Title = {
  @react.component
  let make = (~children) => {
    <Title style=title>
      { children }
    </Title>
  }
}
