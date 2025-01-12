@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  let {t} = ReactI18next.useTranslation()
  let (access, setAccess) = React.useState(_ => None)

  let next = _ => {
    dispatch(ElectionNewState.SetAccess(Option.getExn(access)))
    dispatch(ElectionNewState.SetStep(Step4))
  }

  let value = switch access {
  | None => ""
  | Some(#"open") => "open"
  | Some(#"closed") => "closed"
  }

  let valueToAccess = x => {
    switch x {
    | "open" => Some(#"open")
    | "closed" => Some(#"closed")
    | _ => None
    }
  }

  <>
    <Header title="Nouvelle élection" subtitle="3/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "Comment participer ?" -> React.string }
    </Title>

    <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
      <RadioButton.Group
        value
        onValueChange={v => {
          setAccess(_ => valueToAccess(v))
          v
        }}
      >
        <TouchableOpacity onPress={_ => setAccess(_ => Some(#"open"))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="open" status=(if access == Some(#"open") { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Participation ouverte"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "Les participant-es peuvent rejoindre librement l'élection grâce à un lien ou un QR code."
              ->React.string
            }
          </Text>
        </TouchableOpacity>

        <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

        <TouchableOpacity onPress={_ => setAccess(_ => Some(#closed))}>
          <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
            <RadioButton value="closed" status=(if access == Some(#"closed") { #checked } else { #unchecked }) />
            <Text
              style=Style.textStyle(
                ~color=Color.black,
                ~fontSize=18.0,
                ~fontWeight=Style.FontWeight._700,
                (),
              )
            >
              { "Participation fermée"->React.string }
            </Text>
          </View>
          <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
            {
              "L’administrateur·ice de l’élection doit inviter chaque participant·e, en général via une liste d’e-mails."
              ->React.string
            }
          </Text>
        </TouchableOpacity>
      </RadioButton.Group>
    </View>

    //<View
    //  style=Style.viewStyle(
    //    ~flexDirection=#row,
    //    ~justifyContent=#spaceBetween,
    //    ~marginTop=24.0->Style.dp,
    //    (),
    //  )
    //>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
  //let (state, dispatch) = StateContext.use()
  //let {t} = ReactI18next.useTranslation()

  //let (value, setValue) = React.useState(_ => "closed")

  //if (state.newElection.title == "") {
  //  dispatch(StateMsg.Navigate(list{"elections", "new"}))
  //}

  //let electionCreate = _ => {
  //  let mode = switch value {
  //  | "open" => State.Open
  //  | "closed" => State.Closed
  //  | _ => State.Undefined
  //  }
  //  // TODO: Dispatch mode
  //  let newElection = {...state.newElection, mode}
  //  dispatch(StateMsg.UpdateNewElection(newElection))

  //  //if mode == State.Open {
  //  //  dispatch(CreateOpenElection)
  //  //  dispatch(StateMsg.Navigate(list{"elections", "new", "step4"}))
  //  //} else {
  //  //  dispatch(StateMsg.Navigate(list{"elections", "new", "step5"}))
  //  //}
  //  // TODO: Remove
  //  //Core.Election.create(~name, ~desc, ~choices)(state, dispatch)
  //}

  //<>
  //  <Header title={t(. "election.new.header")} />
  //  <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
  //    <Title style=Style.textStyle(~fontSize=32.0, ())>
  //      { t(. "election.new3.title") -> React.string }
  //    </Title>
  //  </View>

  //  <RadioButton.Group
  //    onValueChange={v => {setValue(_ => v); v}}
  //    value=value
  //    >
  //    <View>
  //      <RadioButtonItem label={t(. "election.new3.closed.title")} value="closed" />
  //      <Text>
  //        {t(. "election.new3.closed.description")->React.string}
  //      </Text>
  //    </View>
  //    <View>
  //      <RadioButtonItem label={t(. "election.new3.open.title")} value="open"
  //      />
  //      <Text>
  //        {t(. "election.new3.open.description")->React.string}
  //      </Text>
  //    </View>
  //  </RadioButton.Group>

  //  <S.Button
  //    title={t(. "election.new.next")}
  //    disabled=(value == "")
  //    onPress=electionCreate
  //    />
  //</>
}
