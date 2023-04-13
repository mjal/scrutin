@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let title = switch state.route {
  | list{"elections", "new"} => t(."election.new.title") -> React.string
  | _ => <></>
  }

  let backButton = switch state.route {
  | list{} | list{""} => <></>
  | _ => <Appbar.Action
      icon=Icon.name("arrow-left")
      onPress={_ => dispatch(Navigate(list{}))} />
  }

  let settingsButton = switch state.route {
  | list{} | list{""} => <Appbar.Action
    icon=Icon.name("cog-outline")
    onPress={_ => dispatch(Navigate(list{"settings"}))} />
  | _ => <></>
  }

  let titleStyle = Style.viewStyle(~alignSelf=#center,())

  <Appbar.Header style=Style.viewStyle(~backgroundColor=Color.white,())>
    { backButton }
    <Appbar.Content title titleStyle />
    { settingsButton }
  </Appbar.Header>
}
