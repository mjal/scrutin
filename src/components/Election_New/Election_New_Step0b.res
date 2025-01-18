type date_params_t = { date: Js.nullable<Js.Date.t> }
type time_params_t = { hours: Js.nullable<int>, minutes: Js.nullable<int> }

@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let {t} = ReactI18next.useTranslation()
  // TODO: Use Js.Nullable.t to simplify
  let (startDate: option<Js.Date.t>, setStartDate) = React.useState(_ => None);
  let (endDate: option<Js.Date.t>, setEndDate) = React.useState(_ => None);
  let (visible0, setVisible0) = React.useState(_ => false);
  let (visible1, setVisible1) = React.useState(_ => false);
  let (visible2, setVisible2) = React.useState(_ => false);
  let (visible3, setVisible3) = React.useState(_ => false);

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step1,
      ?startDate,
      ?endDate,
    })
  }

  let previous = _ => {
    setState(_ => {
      ...state,
      step: Step0,
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <S.Section title={t(. "election.new.title")} />

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      {
        switch startDate {
        | Some(startDate) =>
          `Date de début: ${Js.Date.toString(startDate)}.` -> React.string
        | None => `Sans date de début (optionnelle)` -> React.string
        }
      }
    </Title>

    <S.Row>
      <S.Col>
        <S.Button
          title="Changer la date de début"
          onPress={_ => setVisible0(_ => true)}
          />
      </S.Col>
      <S.Col>
        <S.Button
          title="Changer l'heure de début"
          onPress={_ => setVisible1(_ => true)}
          />
      </S.Col>
    </S.Row>

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      {
        switch endDate {
        | Some(endDate) =>
          `Date de fin: ${Js.Date.toUTCString(endDate)}.` -> React.string
        | None => `Sans date de fin (optionnelle)` -> React.string
        }
      }
    </Title>

    <S.Row>
      <S.Col>
        <S.Button
          title="Changer la date de fin"
          onPress={_ => setVisible2(_ => true)}
          />
      </S.Col>
      <S.Col>
        <S.Button
          title="Changer l'heure de fin"
          onPress={_ => setVisible3(_ => true)}
          />
      </S.Col>
    </S.Row>

    <Paper__DatePickerModal
      locale="fr"
      mode=#single
      visible=visible0
      onDismiss={_ => setVisible0(_ => false)}
      onConfirm={(params) => {
        let params: date_params_t = Obj.magic(params)
        setStartDate(_ => {
          Option.map(Js.Nullable.toOption(params.date), (x) => Js.Date.fromFloat(Js.Date.valueOf(x) +. 1.0))
        })
        setVisible0(_ => false)
      }}
      date=Js.Nullable.fromOption(startDate)
    />

    <Paper__TimePickerModal
      locale="fr"
      visible=visible1
      onDismiss={_ => setVisible1(_ => false)}
      onConfirm={(params) => {
        let params: time_params_t = Obj.magic(params)
        let hours = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.hours), 0))
        let minutes = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.minutes), 0))
        setStartDate(_ => Option.map(startDate, (d) => Js.Date.fromFloat(Js.Date.setHoursM(d, ~hours, ~minutes, ()))))
        setVisible1(_ => false)
      }}
      hours=Js.Nullable.null
      minutes=Js.Nullable.null
    />

    <Paper__DatePickerModal
      locale="fr"
      mode=#single
      visible=visible2
      onDismiss={_ => setVisible2(_ => false)}
      onConfirm={(params) => {
        let params: date_params_t = Obj.magic(params)
        setEndDate(_ => {
          Option.map(Js.Nullable.toOption(params.date), (x) => Js.Date.fromFloat(Js.Date.valueOf(x) +. 1.0))
        })
        setVisible2(_ => false)
      }}
      date=Js.Nullable.fromOption(endDate)
    />

    <Paper__TimePickerModal
      locale="fr"
      visible=visible3
      onDismiss={_ => setVisible3(_ => false)}
      onConfirm={(params) => {
        let params: time_params_t = Obj.magic(params)
        let hours = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.hours), 0))
        let minutes = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.minutes), 0))
        setEndDate(_ => Option.map(endDate, (d) => Js.Date.fromFloat(Js.Date.setHoursM(d, ~hours, ~minutes, ()))))
        setVisible3(_ => false)
      }}
      hours=Js.Nullable.null
      minutes=Js.Nullable.null
    />

    <Election_New_Previous_Next next previous />
  </>
}

