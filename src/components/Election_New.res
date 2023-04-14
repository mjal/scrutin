@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let (name, setName) = React.useState(_ => "")
  let desc = ""
  let (choices, setChoices) = React.useState(_ => ["", ""])

  let electionCreate = _ => {
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  let styles = {
    open Style
    StyleSheet.create({
      "questionInput": viewStyle(
        ~marginHorizontal=25.0->dp,
        ~backgroundColor=Color.white,
        ~shadowRadius=2.0,
      ())
    })
  }

  <>
    <Header title=t(."election.new.header") />

    <Title style=S.section>
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

    <Election_New_ChoiceList choices setChoices />

    <S.Button onPress=electionCreate title=t(."election.new.next") />
  </>
}
