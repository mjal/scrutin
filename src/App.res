// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative

@react.component
let make = () => {
  //let url = RescriptReactRouter.useUrl()
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  if !state.init {
    dispatch(Action.Init)
  }

  <State.StateContext.Provider value=state>
    <State.DispatchContext.Provider value=dispatch>
      <SafeAreaView>
        <Text style=X.styles["title"]>{"Scrutin.app" -> React.string}</Text>
        <Text style=X.styles["subtitle"]>{"Enjoy end-to-end encrypted elections"  -> React.string}</Text>
        {switch state.route {
          | Home => <HomeView></HomeView>
          | ElectionNew => <ElectionNew></ElectionNew>
          | _ => <Text>{"Not found" -> React.string}</Text>
        }}
      </SafeAreaView>
    </State.DispatchContext.Provider>
  </State.StateContext.Provider>
}