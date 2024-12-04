@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (value, setValue) = React.useState(_ => "closed")

  if (state.newElection.title == "") {
    dispatch(StateMsg.Navigate(list{"elections", "new"}))
  }

  let electionCreate = _ => {
    let mode = switch value {
    | "open" => State.Open
    | "closed" => State.Closed
    | _ => State.Undefined
    }
    // TODO: Dispatch mode
    let newElection = {...state.newElection, mode}
    dispatch(StateMsg.UpdateNewElection(newElection))

    if mode == State.Open {
      dispatch(CreateOpenElection)
      dispatch(StateMsg.Navigate(list{"elections", "new", "step4"}))
    } else {
      dispatch(StateMsg.Navigate(list{"elections", "new", "step5"}))
    }
    // TODO: Remove
    //Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  }

  <>
    <Header title={t(. "election.new.header")} />
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <Title style=Style.textStyle(~fontSize=32.0, ())>
        { t(. "election.new3.title") -> React.string }
      </Title>
    </View>

    <RadioButton.Group
      onValueChange={v => {setValue(_ => v); v}}
      value=value
      >
      <View>
        <RadioButtonItem label={t(. "election.new3.closed.title")} value="closed" />
        <Text>
          {t(. "election.new3.closed.description")->React.string}
        </Text>
      </View>
      <View>
        <RadioButtonItem label={t(. "election.new3.open.title")} value="open"
        />
        <Text>
          {t(. "election.new3.open.description")->React.string}
        </Text>
      </View>
    </RadioButton.Group>

    <S.Button
      title={t(. "election.new.next")}
      disabled=(value == "")
      onPress=electionCreate
      />
  </>
}
