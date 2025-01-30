@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()

  let endDate = Js.Nullable.fromOption(state.endDate)
  let setEndDate = get => {
    let endDate = Js.Nullable.toOption(get())
    setState(_ => {...state, ?endDate})
  }

  let next = _ => setState(_ => { ...state, step: Step1, })
  let previous = _ => setState(_ => { ...state, step: Step0b, })

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <S.H1 text="Quand se termine cette élection ?" />

      <Election_New_Date date=endDate setDate=setEndDate noText="Quand je le décide" />
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
