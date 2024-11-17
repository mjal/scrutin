@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (choices, setChoices) = React.useState(_ => ["", ""])

  if (state.newElection.title == "") {
    dispatch(StateMsg.Navigate(list{"elections", "new"}))
  }

  let electionCreate = _ => {
    let desc = ""
    let name = state.newElection.title
    let choices = Array.mapWithIndex(choices, (i, choice) => {
      switch choice {
      | "" => "Choice " ++ Int.toString(i+1)
      | _  => choice
      }
    })
    Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  <>
    <Header title={t(. "election.new.header")} />
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { state.newElection.title->React.string }
      </Title>
    </View>
    //<S.Title>{ state.newElection.title -> React.string }</S.Title>

    <ElectionNewChoiceList choices setChoices />

    <S.Button onPress=electionCreate title={t(. "election.new.next")} />
  </>
}
