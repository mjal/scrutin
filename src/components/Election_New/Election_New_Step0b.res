@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()

  let startDate = Js.Nullable.fromOption(state.startDate)
  let setStartDate = get => {
    let startDate = Js.Nullable.toOption(get())
    setState(_ => {...state, ?startDate})
  }

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

    <S.Container>
      <S.H1 text="Quand commence cette élection ?" />

      <Election_New_Date date=startDate setDate=setStartDate noText="Dès maintenant" />
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
