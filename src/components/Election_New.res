@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => [])

  let electionCreate = _ => {
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  let ownerDescription = switch state.ids[0] {
  | Some(user) => user.hexPublicKey
  | None => t(."election.new.noPublicKey")
  }

  <>
    <TextInput
      mode=#flat
      label=t(."election.new.name")
      testID="election-name"
			value=name
      onChangeText={text => setName(_ => text)}
    />

    <TextInput
      mode=#flat
      label=t(."election.new.description")
      testID="election-desc"
			value=desc
      onChangeText={text => setDesc(_ => text)}
    />

    <Election_New_ChoiceList choices setChoices />

    <List.Item
      title=t(."election.new.owner")
      description=ownerDescription />

    <Button mode=#contained onPress=electionCreate>
      { t(."election.new.create") -> React.string }
    </Button>
  </>
}
