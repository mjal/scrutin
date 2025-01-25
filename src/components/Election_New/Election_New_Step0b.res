@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let (startDate: Js.Nullable.t<Js.Date.t>, setStartDate) = React.useState(_ => Js.Nullable.null);
  //let { t } = ReactI18next.useTranslation()

  let next = _ => {
    let startDate = Js.Nullable.toOption(startDate)
    setState(_ => {
      ...state,
      step: Step0c,
      ?startDate,
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

    <S.H1>
      { "Quand commence cette élection ?" -> React.string }
    </S.H1>

    <Election_New_Date date=startDate setDate=setStartDate noText="Dès maintenant" />

    <Election_New_Previous_Next next previous />
  </>
}
