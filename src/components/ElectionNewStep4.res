@react.component
let make = () => {
  <Title style=Style.textStyle(~fontSize=32.0, ())>
    { "En cours de création..." -> React.string }
  </Title>
}
