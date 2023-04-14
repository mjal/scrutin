@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let buttonStyle = Style.viewStyle(
    ~paddingVertical=5.0->Style.dp,
    ~marginTop=20.0->Style.dp,
    ~marginBottom=20.0->Style.dp,
    ~width=330.0->Style.dp,
    ~alignSelf=#center,
    ~borderRadius=0.0,
    ()
  )

  let buttonTextStyle = Style.textStyle(
    ~fontSize=20.0,
    ~color=Color.white,
    ()
  )

  <>
    <Header />

    <Logo />

    <S.Button title=t(."home.create")
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))} />

    <Button mode=#text onPress={_ => dispatch(Navigate(list{"elections"}))}>
      { t(."home.search") -> React.string }
    </Button>
  </>
}

