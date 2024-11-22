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
      style=Style.viewStyle(~width=300.0->Style.dp, ~paddingVertical=12.0->Style.dp, ())
      titleStyle=Style.textStyle(~fontSize=18.0, ())
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}
    />
    { switch ReactNative.Platform.os {
    | #web =>
      <Button mode=#text onPress={_ => dispatch(Navigate(list{"elections", "search"}))}>
        {t(. "home.search")->React.string}
      </Button>
    | _ =>
    <>
      <View style=Style.viewStyle(~height=50.0->Style.dp,()) />
      <View>
        <View>// style=Style.viewStyle(~height=414.0->Style.dp,())>
          <HomeBackground />
        </View>
        <TouchableOpacity style=styles["aboutView"]
          onPress={_ => dispatch(StateMsg.Navigate_About)} >
          <SIcon.ButtonAbout />// style=styles["aboutButton"] />
        </TouchableOpacity>
        <TouchableOpacity style=styles["searchView"]
          onPress={_ => dispatch(Navigate(list{"elections", "search"}))}>
          <SIcon.ButtonSearch />// style=styles["searchButton"] />
        </TouchableOpacity>
      </View>
    </>
    } }
  </View>
}
