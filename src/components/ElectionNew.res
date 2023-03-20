@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => [])

  let electionCreate = _ => {
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  let ownerDescription = switch state.ids[0] {
  | Some(user) => user.hexPublicKey
  | None => "No public key found"
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

    <ElectionNew_ChoiceList choices setChoices />

    <List.Item title="Owner" description=ownerDescription />

    <Button mode=#contained onPress=electionCreate>
      {"Create" -> React.string}
    </Button>
  </>
}
