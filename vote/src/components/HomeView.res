@react.component
let make = () => {
  let (_state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  <View>
    //<Header />
    <View style={Style.viewStyle(~height=50.0->Style.dp, ())} />
    //<Image source=Logo.source style=Style.viewStyle(~alignSelf=#center, ~width=360.0->Style.dp, ~height=139.0->Style.dp, ()) />

    // Align the logo to the center
    <View style={Style.viewStyle(~alignItems=#center, ~margin=20.0->Style.dp, ())}>
      <ScrutinLogo width=400 height=200 />
    </View>
    <S.Button
      title={t(. "home.create")}
      style={Style.viewStyle(~width=300.0->Style.dp, ~paddingVertical=12.0->Style.dp, ())}
      titleStyle={Style.textStyle(~fontSize=18.0, ())}
      onPress={_ => dispatch(Navigate(list{"elections", "new"}))}
    />
    <TouchableOpacity
      style={Style.viewStyle(
        ~marginTop=20.0->Style.dp,
        ~alignItems=#center,
        ~paddingVertical=12.0->Style.dp,
        (),
      )}
      onPress={_ => {
        ReactNative.Linking.openURL("https://docs.scrutin.app")->ignore
      }}>
      <Text
        style={Style.textStyle(
          ~fontSize=20.0,
          ~color=Color.blue,
          ~textDecorationLine=#underline,
          (),
        )}>
        {"Documentation"->React.string}
      </Text>
    </TouchableOpacity>
    <TouchableOpacity
      style={Style.viewStyle(
        ~marginTop=20.0->Style.dp,
        ~alignItems=#center,
        ~paddingVertical=12.0->Style.dp,
        (),
      )}
      onPress={_ => {
        ReactNative.Linking.openURL("https://github.com/mjal/scrutin")->ignore
      }}>
      <Text
        style={Style.textStyle(
          ~fontSize=20.0,
          ~color=Color.blue,
          ~textDecorationLine=#underline,
          (),
        )}>
        {"Source code"->React.string}
      </Text>
    </TouchableOpacity>
    <TouchableOpacity
      style={Style.viewStyle(
        ~marginTop=20.0->Style.dp,
        ~alignItems=#center,
        ~paddingVertical=12.0->Style.dp,
        (),
      )}
      onPress={_ => {
        ReactNative.Linking.openURL("https://framagroupes.org/sympa/subscribe/scrutin")->ignore
      }}>
      <Text
        style={Style.textStyle(
          ~fontSize=20.0,
          ~color=Color.blue,
          ~textDecorationLine=#underline,
          (),
        )}>
        {"Join the mailing list"->React.string}
      </Text>
    </TouchableOpacity>
  </View>
}
