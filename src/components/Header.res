@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <Appbar.Header>
    <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(Home_Elections))} />
    <Appbar.Content title={ t(."app.title") -> React.string } />
    <Appbar.Action icon=Icon.name("cog-outline") onPress={_ => dispatch(Navigate(Route.Settings))}></Appbar.Action>
  </Appbar.Header>
}
