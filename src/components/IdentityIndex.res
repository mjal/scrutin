module Modal_Import = {
  @react.component
  let make = (~visible, ~setVisible, ~onImport) => {
    let {t} = ReactI18next.useTranslation()
    let (importedPrivateKey, setImportedPrivateKey) = React.useState(_ => "")

    let onSubmit = () => {
      onImport(importedPrivateKey)
      setVisible(_ => false)
    }

    <Portal>
      <Modal visible onDismiss={_ => setVisible(_ => false)}>
        <View style={S.flatten([S.modal, S.layout])} testID="choice-modal">
          <TextInput
            mode=#flat
            label={t(. "identity.home.modal.privateKey")}
            testID="input-import-private-key"
            autoFocus=true
            value=importedPrivateKey
            onChangeText={text => setImportedPrivateKey(_ => text)}
            onSubmitEditing={_ => onSubmit()}
          />
          <Button mode=#contained onPress={_ => onSubmit()}>
            {t(. "identity.home.modal.add")->React.string}
          </Button>
        </View>
      </Modal>
    </Portal>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()
  let (visibleImportModal, setVisibleImportModal) = React.useState(_ => false)

  <>
    <S.Title> {t(. "identity.home.title")->React.string} </S.Title>
    <List.Section title="" style=S.marginX>
      {Array.map(state.ids, id => {
        <Card key=id.hexPublicKey>
          <List.Item
            title={"0x" ++ id.hexPublicKey}
            onPress={_ => dispatch(Navigate(list{"identities", id.hexPublicKey}))}
          />
        </Card>
      })->React.array}
    </List.Section>
    <S.Title> {"-"->React.string} </S.Title>
    <Button
      mode=#contained
      onPress={_ => {
        dispatch(Identity_Add(Account.make()))
      }}>
      {t(. "identity.home.generate")->React.string}
    </Button>
    <S.Title> {"-"->React.string} </S.Title>
    <Button
      mode=#contained
      onPress={_ => {
        setVisibleImportModal(_ => true)
      }}>
      {t(. "identity.home.import")->React.string}
    </Button>
    <S.Title> {"-"->React.string} </S.Title>
    <Button
      mode=#outlined
      onPress={_ => {
        Account.clear()
        dispatch(Reset)
      }}>
      {t(. "identity.home.clear")->React.string}
    </Button>
    <S.Title> {"-"->React.string} </S.Title>
    <Modal_Import
      visible=visibleImportModal
      setVisible=setVisibleImportModal
      onImport={hexSecretKey => {
        dispatch(Identity_Add(Account.make2(~hexSecretKey)))
      }}
    />
  </>
}
