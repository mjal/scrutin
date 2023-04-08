module Modal_Import = {
  @react.component
  let make = (~visible, ~setVisible, ~onImport) => {
    let { t } = ReactI18next.useTranslation()
    let (importedPrivateKey, setImportedPrivateKey) = React.useState(_ => "")

    let onSubmit = () => {
      onImport(importedPrivateKey)
      setVisible(_ => false)
    }

    <Portal>
      <Modal visible
        onDismiss={_ => setVisible(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])
          testID="choice-modal">
          <TextInput
            mode=#flat
            label=t(."identity.home.modal.privateKey")
            testID="input-import-private-key"
            autoFocus=true
            value=importedPrivateKey
            onChangeText={text => setImportedPrivateKey(_ => text)}
            onSubmitEditing={_=>onSubmit()}
          />
          <Button mode=#contained onPress={_=> onSubmit()}>
            { t(."identity.home.modal.add") -> React.string }
          </Button>
        </View>
      </Modal>
    </Portal>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (visibleImportModal, setVisibleImportModal) = React.useState(_ => false)

  <>
    <X.Title>
      { t(."identity.home.title") -> React.string }
    </X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.map(state.ids, (id) => {
      <Card key=id.hexPublicKey>
        <List.Item
          title=("0x" ++ id.hexPublicKey)
          onPress={_ => dispatch(Navigate(Identity_Show(id.hexPublicKey)))}
        />
      </Card>
    }) -> React.array }
    </List.Section>

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress={_ => {
      dispatch(Identity_Add(Identity.make()))
    }}>
      { t(."identity.home.generate") -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress={_ => {
      setVisibleImportModal(_ => true)
    }}>
      { t(."identity.home.import") -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#outlined onPress={_ => {
      Identity.clear()
      dispatch(Reset)
    }}>
      { t(."identity.home.clear") -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>
    
    <Modal_Import visible=visibleImportModal
      setVisible=setVisibleImportModal
      onImport={ hexSecretKey => {
        dispatch(Identity_Add(Identity.make2(~hexSecretKey)))
      } }
      />
  </>
}
