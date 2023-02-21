// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative
open Paper

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(Action.Init)
    None
  })

  <PaperProvider theme=Paper.ThemeProvider.Theme.make(~dark=true, ())>
    <Context.State.Provider value=state>
      <Context.Dispatch.Provider value=dispatch>
        <SafeAreaView style=X.styles["layout"]>
          <ScrollView>
            <Appbar.Header>
              <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(Route.Home))}></Appbar.Action>
              <Appbar.Content title={"" -> React.string} />
              <Appbar.Action icon=Icon.name("account") onPress={_ => dispatch(Navigate(Route.User_Profile))}></Appbar.Action>
            </Appbar.Header>
            {switch state.route {
            | Home => <Home />
            | ElectionNew => <ElectionNew />
            | ElectionBooth(_uuid)
            | ElectionResult(_uuid)
            | ElectionShow(_uuid) => <ElectionShow />
            | User_Profile => <User_Profile />
            | User_Signin => <User_Signin />
            | User_Signup => <User_Signup />
            }}
          </ScrollView>
        </SafeAreaView>
      </Context.Dispatch.Provider>
    </Context.State.Provider>
  </PaperProvider>
}