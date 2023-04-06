@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t, i18n } = ReactI18next.useTranslation()

  <>
    <List.Section
      title=t(."settings.language")
      style=X.styles["margin-x"]>
      <X.SegmentedButtons
        value=i18n.language
        buttons=[
          {value: "en", label: "English"},
          {value: "fr", label: "Français"}
        ]
        onValueChange={lang => {
          i18n.changeLanguage(. lang)
        }}
      />
    </List.Section>

    <List.Section title=t(."settings.internals") style=X.styles["margin-x"]>
      <List.Item title=t(."settings.identities")
        onPress={_ => dispatch(Navigate(Home_Identities))}
      />
      <List.Item title=t(."settings.trustees")
        onPress={_ => dispatch(Navigate(Home_Trustees))}
      />
      <List.Item title=t(."settings.contacts")
        onPress={_ => dispatch(Navigate(Contact_Index))}
      />
      <List.Item title=t(."settings.transactions")
        onPress={_ => dispatch(Navigate(Home_Transactions))}
      />
    </List.Section>
  </>
}
