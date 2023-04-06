@react.component
let make = (~state, ~dispatch, ~children) => {
  <PaperProvider theme=Paper.ThemeProvider.Theme.make(~dark=true, ())>
    <Context.State.Provider value=state>
      <Context.Dispatch.Provider value=dispatch>
        <SafeAreaView style=X.styles["layout"]>
          <ScrollView>
            {children}
          </ScrollView>
        </SafeAreaView>
      </Context.Dispatch.Provider>
    </Context.State.Provider>
  </PaperProvider>
}
