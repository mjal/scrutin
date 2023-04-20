@react.component
let make = (~text) => {
  let { t } = ReactI18next.useTranslation()
  let (visible, setVisible) = React.useState(_ => false);

  <>
    <S.Button onPress={_ => {
      Clipboard_.writeText(text) -> ignore
      setVisible(_ => true)
    } }
    title=t(."utils.copybutton.text") />

    <Portal>
      <Snackbar
        visible
        duration=Snackbar.Duration.value(2000)
        onDismiss={_ => setVisible(_ => false)}>
        { t(."utils.copybutton.feedback") -> React.string }
      </Snackbar>
    </Portal>
  </>
}
