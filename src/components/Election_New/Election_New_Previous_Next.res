@react.component
let make = (~next, ~previous) => {
  let { t } = ReactI18next.useTranslation()

  //let style = Style.viewStyle(
  //  ~flexDirection=#row,
  //  ~justifyContent=#"space-between",
  //  ~marginTop=20.0->Style.dp,
  //  ())

  //<View style>
  <S.Row>
    <S.Col>
      <S.Button
        title="Précédent"
        titleStyle=Style.textStyle(~color=Color.black, ())
        mode=#outlined
        onPress={_ => previous()}
      />
    </S.Col>

    <S.Col>
      <S.Button
        title={t(. "election.new.next")}
        onPress={_ => next()}
      />
    </S.Col>
  </S.Row>
}
