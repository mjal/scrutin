module Modal_Import = {
  @react.component
  let make = (~visible, ~setVisible, ~onImport) => {
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
            label="Private key"
            testID="input-import-private-key"
            autoFocus=true
            value=importedPrivateKey
            onChangeText={text => setImportedPrivateKey(_ => text)}
            onSubmitEditing={_=>onSubmit()}
          />
          <Button mode=#contained onPress={_=> onSubmit()}>
            { "Ajouter" -> React.string }
          </Button>
        </View>
      </Modal>
    </Portal>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (visibleImportModal, setVisibleImportModal) = React.useState(_ => false)

  <>
    <X.Title>{ "Identités" -> React.string }</X.Title>
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
      { "Generate identity" -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress={_ => {
      setVisibleImportModal(_ => true)
    }}>
      { "Import identity" -> React.string }
    </Button>

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#outlined onPress={_ => {
      Identity.clear()
      dispatch(Reset)
    }}>
      { "Clear identities" -> React.string }
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
