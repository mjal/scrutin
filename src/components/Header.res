@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let title = switch X.env {
  | #prod => t(."app.title") -> React.string
  | #dev =>
    <Text style=Style.textStyle(~color=Color.red,())>
      { (t(."app.title") ++ " [DEV MODE]") -> React.string }
    </Text>
  }

  <Appbar.Header>
    <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(Election_Index))} />
    <Appbar.Content title />
    <Appbar.Action icon=Icon.name("cog-outline") onPress={_ => dispatch(Navigate(Route.Settings))}></Appbar.Action>
  </Appbar.Header>
}
