@react.component
let make = (~date, ~setDate, ~noText) => {
  let (visible, setVisible) = React.useState(_ => false);

  let hasDate = switch Js.Nullable.toOption(date) {
  | None => "no"
  | Some(_) => "yes"
  }

  <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
    <RadioButton.Group
      value=hasDate
      onValueChange={v => {
        if v == "no" { setDate(_ => Js.Nullable.null) }
        v
      }}
    >
      <TouchableOpacity onPress={_ => {
        setDate(_ => Js.Nullable.null)
      }}>
        <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
          <RadioButton value="no" status=(if hasDate == "no" { #checked } else { #unchecked }) />
          <Text
            style=Style.textStyle(
              ~color=Color.black,
              ~fontSize=18.0,
              ~fontWeight=Style.FontWeight._700,
              (),
            )
          >
            { noText->React.string }
          </Text>
        </View>
      </TouchableOpacity>

      <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

      <TouchableOpacity onPress={_ => {
        setDate(_ => {
          switch Js.Nullable.toOption(date) {
          | Some(_) => date
          | None =>
            let date = Js.Date.make()
            let date = Js.Date.fromFloat(Js.Date.setHoursM(date, ~hours=0.0, ~minutes=0.0, ()))
            Js.Nullable.return(date)
          }
        })
      }}>
        <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
          <RadioButton value="yes" status=(if hasDate == "yes" { #checked } else { #unchecked }) />
          <Text style=Style.textStyle(
            ~color=Color.black,
            ~fontSize=18.0,
            ~fontWeight=Style.FontWeight._700,
            ())>
            { "À un moment précis"->React.string }
          </Text>
        </View>

        <Paper__DatePickerInput
          locale="fr"
          label="Date"
          inputMode=#start
          value=date
          startWeekOnMonday=true
          onChange={(date) => {
            switch (Js.Nullable.toOption(date)) {
            | None => ()
            | Some(date) => setDate(_ => Js.Nullable.return(date))
            }
          }}
        />

        { if hasDate == "yes" {
          <>
            <S.Row>
              <S.Col>
                {
                  let hours = Js.Nullable.toOption(date)
                    ->Option.map(Js.Date.getHours)
                    ->Option.getWithDefault(0.0)
                    ->Float.toString
                  let hours = if String.length(hours) == 1 { "0" ++ hours } else { hours }

                  let minutes = Js.Nullable.toOption(date)
                    ->Option.map(Js.Date.getMinutes)
                    ->Option.getWithDefault(0.0)
                    ->Float.toString
                  let minutes = if String.length(minutes) == 1 { "0" ++ minutes } else { minutes }

                  <S.P text=`Heure: ${hours}:${minutes}` />
                }
              </S.Col>
              <S.Col>
                <S.Button
                  title="Changer l'heure"
                  onPress={_ => setVisible(_ => true)}
                  />
                <Paper__TimePickerModal
                  locale="fr"
                  visible=visible
                  onDismiss={_ => setVisible(_ => false)}
                  onConfirm={(params) => {
                    let hours = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.hours), 0))
                    let minutes = Int.toFloat(Option.getWithDefault(Js.Nullable.toOption(params.minutes), 0))
                    let date = Js.Nullable.toOption(date)->Option.map((d) => Js.Date.fromFloat(Js.Date.setHoursM(d, ~hours, ~minutes, ())))
                    setDate(_ => Js.Nullable.fromOption(date))
                    setVisible(_ => false)
                  }}
                  hours=Js.Nullable.null
                  minutes=Js.Nullable.null
                />
              </S.Col>
            </S.Row>
          </>
        } else { <></> }}
      </TouchableOpacity>
    </RadioButton.Group>
  </View>
}

