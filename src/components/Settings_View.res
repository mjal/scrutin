@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t, i18n } = ReactI18next.useTranslation()

  let language = switch i18n.language {
  | "en-US"  => "en"
  | language => language
  }

  <>
    <Header />

    <List.Section
      title=t(."settings.language")
      style=S.marginX>
      <S.SegmentedButtons
        value=language
        buttons=[
          {value: "en", label: "English"},
          {value: "fr", label: "Français"},
          {value: "nb_NO", label: "Norsk"}
        ]
        onValueChange={lang => {
          i18n.changeLanguage(. lang)
          dispatch(Config_Store_Language(lang))
        }}
      />
    </List.Section>

    <List.Section title=t(."settings.internals") style=S.marginX>
      <List.Item title=t(."settings.identities")
        onPress={_ => dispatch(Navigate(list{"identities"}))}
      />
      <List.Item title=t(."settings.trustees")
        onPress={_ => dispatch(Navigate(list{"trustees"}))}
      />
      <List.Item title=t(."settings.contacts")
        onPress={_ => dispatch(Navigate(list{"contacts"}))}
      />
      <List.Item title=t(."settings.events")
        onPress={_ => dispatch(Navigate(list{"events"}))}
      />
    </List.Section>
  </>
}
