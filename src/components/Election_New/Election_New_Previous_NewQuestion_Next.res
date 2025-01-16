@react.component
let make = (~next, ~newQuestion, ~previous) => {
  let { t } = ReactI18next.useTranslation()

  let style = Style.viewStyle(
    ~flexDirection=#row,
    ~justifyContent=#"space-between",
    ~marginTop=20.0->Style.dp,
    ())

  <View style>
    <S.Button
      title="Précédent"
      titleStyle=Style.textStyle(~color=Color.black, ())
      style=Style.viewStyle(~width=200.0->Style.dp, ())
      mode=#outlined
      onPress={_ => previous()}
    />

    <S.Button
      title={"Nouvelle question"}
      style=Style.viewStyle(~width=230.0->Style.dp, ())
      onPress={_ => newQuestion()}
    />

    <S.Button
      title={t(. "election.new.next")}
      style=Style.viewStyle(~width=200.0->Style.dp, ())
      onPress={_ => next()}
    />
  </View>
}
