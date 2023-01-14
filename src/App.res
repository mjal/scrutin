// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  <State.StateContext.Provider value=state>
    <State.DispatchContext.Provider value=dispatch>
      <SafeAreaView>
          <Text>{"Hello with context"->React.string}</Text>
          <HomeView></HomeView>
      </SafeAreaView>
    </State.DispatchContext.Provider>
  </State.StateContext.Provider>
}