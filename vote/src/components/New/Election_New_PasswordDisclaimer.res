@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()

  let next = _ => setState(_ => { ...state, step: Step_Password, })
  let previous = _ => setState(_ => { ...state, step: Step4, })

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <S.H1 text="En tant qu'administrateur de l'élection, vous co-protegez le secret du vote via un mot de passe dépouillement qui va vous être communiqué." />
    </S.Container>

    <Election_New_Previous_Next next previous />
  </>
}
