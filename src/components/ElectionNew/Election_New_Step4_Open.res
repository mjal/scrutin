@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  let { t } = ReactI18next.useTranslation()
  let _ = (state, dispatch)

  <>
    <Header title="Nouvelle élection" subtitle="4/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    <Text>{ "Cette election est ouverte." -> React.string }</Text>

    <Text>{ "Vous pourrez partager un lien permettant de voter" -> React.string }</Text>

    <S.Button
      title={t(. "election.new.next")}
      onPress={_ => dispatch(ElectionNewState.SetStep(Step5)) }
      />
  </>
}
