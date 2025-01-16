@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let { t } = ReactI18next.useTranslation()

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step5,
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="4/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Text>{ "Cette election est ouverte." -> React.string }</Text>

    <Text>{ "Vous pourrez partager un lien permettant de voter" -> React.string }</Text>

    <Election_New_Previous_Next next previous={_ => setState(_ => {...state, step: Step3})} />
  </>
}
