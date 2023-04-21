@react.component
let make = () => {
  let (_state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let styles = {
    open Style
    StyleSheet.create({
      "aboutView": viewStyle(
        ~position=#absolute,
        ~left=145.0->dp,
        ~top=150.0->dp,
        ()),
      "aboutButton": viewStyle(
        ~width=80.0->dp,
        ~height=80.0->dp,
        ()),
      "searchView": viewStyle(
        ~position=#absolute,
        ~right=145.0->dp,
        ~top=150.0->dp,
        ()),
      "searchButton": viewStyle(
        ~width=80.0->dp,
        ~height=80.0->dp,
        ())
    })
  }

  <View>
    <Header />
    <Logo />
    <S.Button
      title={t(. "home.create")}
      style=Style.viewStyle(~width=450.0->Style.dp, ~paddingVertical=12.0->Style.dp, ())
      titleStyle=Style.textStyle(~fontSize=25.0, ())
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}
    />
    // NOTE: Keep on web version later
    //<Button mode=#text onPress={_ => dispatch(Navigate(list{"elections", "search"}))}>
    //  {t(. "home.search")->React.string}
    //</Button>
    <View style=Style.viewStyle(~height=50.0->Style.dp,()) />
    <View>
      <HomeBackground />
      <TouchableOpacity style=styles["aboutView"]
        onPress={_ => dispatch(StateMsg.Navigate_About)} >
        <IconButtonAbout style=styles["aboutButton"] />
      </TouchableOpacity>
      <TouchableOpacity style=styles["searchView"]
        onPress={_ => dispatch(Navigate(list{"elections", "search"}))}>
        <IconButtonSearch style=styles["searchButton"] />
      </TouchableOpacity>
    </View>
  </View>
}
