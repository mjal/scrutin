@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (value, setValue) = React.useState(_ => "closed")

  if (state.newElection.title == "") {
    dispatch(StateMsg.Navigate(list{"elections", "new"}))
  }

  let electionCreate = _ => {
    let name = state.newElection.title
    let desc = ""
    let choices = state.newElection.choices
    let mode = switch value {
    | "open" => State.Open
    | "closed" => State.Closed
    | _ => State.Undefined
    }
    // TODO: Dispatch mode
    dispatch(CreateElection)
    dispatch(StateMsg.Navigate(list{"elections", "new", "step4"}))
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

    //<View>
    //  <Text>{ "Hello"->React.string }</Text>
    //  <RadioButton
    //    status=(mode == Open ? #checked : #unchecked)
    //    onPress={_ => setMode(_ => State.Open)}
    //    value="open" />
    //</View>
    //<S.Title> {t(. "election.new3.open.title")->React.string} </S.Title>
    //<S.Title> {t(. "election.new3.open.description")->React.string} </S.Title>

    //<RadioButton
    //  status=(mode == Closed ? #checked : #unchecked)
    //  onPress={_ => setMode(_ => State.Closed)}
    //  value="closed" />
    //<S.Title> {t(. "election.new3.closed.title")->React.string} </S.Title>
    //<S.Title> {t(. "election.new3.closed.description")->React.string} </S.Title>

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
        disabled=true
        />
        <Text>
          {t(. "election.new3.open.description")->React.string}
        </Text>
      </View>
    </RadioButton.Group>

    // "closed.title": "Participation fermée",
    // "closed.description": "L'administrateur.ice de l'élection doit inviter chaque participant.e, en général via une liste l'e-mails.",
    // "open": "Participation ouverte",
    // "open.description": "Les participant.es peuvent rejoindre librement l'élection grâce à un lien ou un QR code.",

    <S.Button
      title={t(. "election.new.next")}
      disabled=(value == "")
      onPress=electionCreate
      />
  </>
}
