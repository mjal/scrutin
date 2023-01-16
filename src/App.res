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
        <Text style=shared_styles["title"]>{"Scrutin.app"->rs}</Text>
        <Text style=shared_styles["subtitle"]>{"Enjoy end-to-end encrypted elections"->rs}</Text>
        {switch state.route {
          | Home => <HomeView></HomeView>
          | ElectionNew => <ElectionNew></ElectionNew>
          | _ => <Text>{"Not found"->rs}</Text>
        }}
      </SafeAreaView>
    </State.DispatchContext.Provider>
  </State.StateContext.Provider>
}