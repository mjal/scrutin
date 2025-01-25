@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let (endDate: Js.Nullable.t<Js.Date.t>, setEndDate) = React.useState(_ => Js.Nullable.null);
  //let { t } = ReactI18next.useTranslation()

  let next = _ => {
    let endDate = Js.Nullable.toOption(endDate)
    setState(_ => {
      ...state,
      step: Step1,
      ?endDate,
    })
  }

  let previous = _ => {
    setState(_ => {
      ...state,
      step: Step0b,
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <S.H1 text="Quand se terminer cette élection ?" />

    <Election_New_Date date=endDate setDate=setEndDate noText="Quand je le décide" />

    <Election_New_Previous_Next next previous />
  </>
}
