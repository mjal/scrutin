@module external source: Image.Source.t = "./Background.svg"

@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let style = Style.viewStyle(
    ~width=100.0->Style.pct,
    ~height=868.0->Style.dp,
    ()
  )

  <View>
    <Header />

    <Logo />

    <S.Button title=t(."home.create")
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))} />

    <Button mode=#text onPress={_ => dispatch(Navigate(list{"elections"}))}>
      { t(."home.search") -> React.string }
    </Button>

    <Image source style />
  </View>
}

