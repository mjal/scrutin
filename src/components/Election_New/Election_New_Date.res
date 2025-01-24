@react.component
let make = (~date, ~setDate, ~noText) => {
  let (hasDate, setHasDate) = React.useState(_ => "no")
  let (visible, setVisible) = React.useState(_ => false);

  <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
    <RadioButton.Group
      value=hasDate
      onValueChange={v => {
        if v == "no" {
          setDate(_ => Js.Nullable.null)
        }
        setHasDate(_ => v)
        v
      }}
    >
      <TouchableOpacity onPress={_ => {
        setHasDate(_ => "no")
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

      <TouchableOpacity onPress={_ => setHasDate(_ => "yes")}>
        <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
          <RadioButton value="yes" status=(if hasDate == "yes" { #checked } else { #unchecked }) />
          <Text
            style=Style.textStyle(
              ~color=Color.black,
              ~fontSize=18.0,
              ~fontWeight=Style.FontWeight._700,
              (),
            )
          >
            { "À un moment précis"->React.string }
          </Text>
        </View>

        { if hasDate == "yes" {
          <>
            <Paper__DatePickerInput
              locale="fr"
              label="Date"
              inputMode=#start
              value=date
              onChange={(date) => {
                switch (Js.Nullable.toOption(date)) {
                | None => ()
                | Some(date) => setDate(_ => Js.Nullable.return(date))
                }
              }}
            />

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

