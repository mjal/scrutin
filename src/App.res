// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative
open Paper

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  if !state.init {
    dispatch(Action.Init)
  }

  let title = switch state.route {
    | Home => "Home"
    | ElectionNew => "Nouvelle election"
    | _ => "Unknown"
  }

  let view = switch state.route {
    | Home => <HomeView></HomeView>
    | ElectionNew => <ElectionNew></ElectionNew>
    | ElectionShow(_id) => <ElectionShow></ElectionShow>
  }

  <Paper.PaperProvider>
    <State.StateContext.Provider value=state>
      <State.DispatchContext.Provider value=dispatch>
        <SafeAreaView>
          <Appbar.Header>
            <Appbar.BackAction onPress={_ => dispatch(Navigate(Route.Home))} />
            <Appbar.Content title={title -> React.string} />
          </Appbar.Header>
          {view}
        </SafeAreaView>
      </State.DispatchContext.Provider>
    </State.StateContext.Provider>
  </Paper.PaperProvider>
}