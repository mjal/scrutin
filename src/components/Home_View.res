@react.component
let make = () => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let buttonStyle = Style.viewStyle(
    ~paddingVertical=10.0->Style.dp,
    ~marginTop=20.0->Style.dp,
    ~marginBottom=20.0->Style.dp,
    ~width=350.0->Style.dp,
    ~alignSelf=#center,
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

    <Button style=buttonStyle mode=#contained
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}>
      <Text style=buttonTextStyle>
        { t(."election.home.create") -> React.string }
      </Text>
    </Button>
    <Button mode=#text onPress={_ => dispatch(Navigate(list{"elections"}))}>
      { "Search an election..." -> React.string }
    </Button>
  </>
}

