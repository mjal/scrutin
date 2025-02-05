@react.component
let make = () => {
  let (_state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  <View>
    //<Header />
    <View style=Style.viewStyle(~height=50.0->Style.dp,()) />
    
    //<Image source=Logo.source style=Style.viewStyle(~alignSelf=#center, ~width=360.0->Style.dp, ~height=139.0->Style.dp, ()) />

    // Align the logo to the center
    <View style=Style.viewStyle(~alignItems=#center, ~margin=20.0->Style.dp, ())>
      <ScrutinLogo />
    </View>

    <S.Button
      title={t(. "home.create")}
      style=Style.viewStyle(~width=300.0->Style.dp, ~paddingVertical=12.0->Style.dp, ())
      titleStyle=Style.textStyle(~fontSize=18.0, ())
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}
    />
    <TouchableOpacity
      style=Style.viewStyle(~marginTop=20.0->Style.dp, ~alignItems=#center, ~paddingVertical=12.0->Style.dp, ())
      onPress={_ => {
        ReactNative.Linking.openURL("https://doc.scrutin.app")->ignore
      }}
    >
      <Text style=Style.textStyle(~fontSize=20.0, ~color=Color.blue, ~textDecorationLine=#underline, ())>
         { "Documentation" -> React.string }
      </Text>
    </TouchableOpacity>
    { switch ReactNative.Platform.os {
    | #web => <></>
    | _ =>
    <>
      <View style=Style.viewStyle(~height=50.0->Style.dp,()) />
      <View>
        <View>// style=Style.viewStyle(~height=414.0->Style.dp,())>
          <HomeBackground />
        </View>
        //<TouchableOpacity style=styles["aboutView"]
        //  onPress={_ => dispatch(StateMsg.Navigate_About)} >
        //  <SIcon.ButtonAbout />// style=styles["aboutButton"] />
        //</TouchableOpacity>
        //<TouchableOpacity style=styles["searchView"]
        //  onPress={_ => dispatch(Navigate(list{"elections", "search"}))}>
        //  <SIcon.ButtonSearch />// style=styles["searchButton"] />
        //</TouchableOpacity>
      </View>
    </>
    } }
  </View>
}
