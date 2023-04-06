@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t, i18n } = ReactI18next.useTranslation()

  <>
    <List.Section title="Language" style=X.styles["margin-x"]>
      <X.SegmentedButtons
        value=i18n.language
        buttons=[
          {value: "en", label: "English"},
          {value: "fr", label: "French"}
        ]
        onValueChange={lang => {
          i18n.changeLanguage(. lang)
        }}
      />
    </List.Section>

    <List.Section title="Internals" style=X.styles["margin-x"]>
      <List.Item title="Identities"
        onPress={_ => dispatch(Navigate(Home_Identities))}
      />
      <List.Item title="Trustees"
        onPress={_ => dispatch(Navigate(Home_Trustees))}
      />
      <List.Item title="Contacts"
        onPress={_ => dispatch(Navigate(Contact_Index))}
      />
      <List.Item title="Transactions"
        onPress={_ => dispatch(Navigate(Home_Transactions))}
      />
    </List.Section>
  </>
}
