@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => [])

  let electionCreate = _ => {
    Core.electionCreate(~name, ~desc, ~choices)(state, dispatch)
  }

  <>
    <TextInput
      mode=#flat
      label="Nom de l'élection"
      testID="election-name"
			value=name
      onChangeText={text => setName(_ => text)}
    />

    <TextInput
      mode=#flat
      label="Description"
      testID="election-desc"
			value=desc
      onChangeText={text => setDesc(_ => text)}
    />

    <Election_New_ChoiceList choices setChoices />

    {
      switch Array.get(state.ids, 0) {
      | Some(user) =>
        <List.Item
          title="Owner"
          description=user.hexPublicKey />
      | None =>
        <List.Item
          title="Owner"
          description="No public key found" />
      }
    }

    <Button mode=#contained onPress=electionCreate>
      {"Create" -> React.string}
    </Button>
  </>
}
