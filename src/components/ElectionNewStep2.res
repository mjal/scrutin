@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (choices, setChoices) = React.useState(_ => ["", ""])

  if (state.newElection.title == "") {
    dispatch(StateMsg.Navigate(list{"elections", "new"}))
  }

  let next = _ => {
    // TODO: Remove map since no empty allowed
    let choices = Array.mapWithIndex(choices, (i, choice) => {
      switch choice {
      | "" => "Choice " ++ Int.toString(i+1)
      | _  => choice
      }
    })
    let newElection = {...state.newElection, choices, mode: State.Open}
    dispatch(StateMsg.UpdateNewElection(newElection))
    //dispatch(CreateOpenElection)
    dispatch(StateMsg.Navigate(list{"elections", "new", "step4"}))
  }

  <>
    <Header title={t(. "election.new.header")} />
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { state.newElection.title->React.string }
      </Title>
    </View>

    <ElectionNewChoiceList choices setChoices />

    <S.Button
      title={t(. "election.new.next")}
      disabled=(!Array.every(choices, (c) => c != ""))
      onPress=next
      />
  </>
}
