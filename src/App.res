// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative

let styles = {
  open Style
  StyleSheet.create({
    "title": textStyle(
      ~textAlign=#center,
      ~fontSize=20.0,
      ()
    ),
    "subtitle": textStyle(
      ~textAlign=#center,
      ()
    ),
  })
}

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  <State.StateContext.Provider value=state>
    <State.DispatchContext.Provider value=dispatch>
      <SafeAreaView>
        <Text style=styles["title"]>{"Scrutin.app"->rs}</Text>
        <Text style=styles["subtitle"]>{"Enjoy end-to-end encrypted elections"->rs}</Text>
        //<HomeView></HomeView>
        <ElectionNew></ElectionNew>
      </SafeAreaView>
    </State.DispatchContext.Provider>
  </State.StateContext.Provider>
}