@react.component
let make = (~state, ~dispatch, ~children) => {
  <PaperProvider theme={Paper.ThemeProvider.Theme.make(~dark=true, ())}>
    <StateContext.State.Provider value=state>
      <StateContext.Dispatch.Provider value=dispatch>
        <SafeAreaView style=S.layout>
          <ScrollView> {children} </ScrollView>
        </SafeAreaView>
      </StateContext.Dispatch.Provider>
    </StateContext.State.Provider>
  </PaperProvider>
}
