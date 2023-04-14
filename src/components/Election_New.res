@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let (name, setName) = React.useState(_ => "")
  let desc = ""
  let (choices, setChoices) = React.useState(_ => [])

  let electionCreate = _ => {
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  let styles = {
    open Style
    StyleSheet.create({
      "section": textStyle(
        ~fontSize=20.0,
        ~marginTop=15.0->dp,
        ~marginBottom=15.0->dp,
        ~marginLeft=60.0->dp,
      ()),
      "questionInput": viewStyle(
        ~marginHorizontal=25.0->dp,
        ~backgroundColor=Color.white,
        ~shadowRadius=2.0,
      ()),
    })
  }

  <>
    <Header title=t(."election.new.header") />

    <Title style=styles["section"]>
      { t(."election.new.question") -> React.string }
    </Title>

    <TextInput
      style=styles["questionInput"]
      mode=#flat
      label=""
      testID="election-name"
			value=name
      onChangeText={text => setName(_ => text)}
    />

    <Title style=styles["section"]>
      { t(."election.new.choiceList.choices") -> React.string }
    </Title>

    <Election_New_ChoiceList choices setChoices />

    <Button mode=#contained onPress=electionCreate>
      { t(."election.new.create") -> React.string }
    </Button>
  </>
}
