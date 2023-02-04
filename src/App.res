// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative
open Paper

@module external belenios: 'a = "./belenios_jslib2"

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)
  let (visibleMenu, setVisibleMenu) = React.useState(_ => false)

  React.useEffect0(() => {
    dispatch(Action.Init)
    None
  })

  let title = switch state.route {
    | Home => "Home"
    | ElectionNew => "Nouvelle election"
    | _ => {
      if state.election.name != "" {
        state.election.name
      } else {
       "Unamed election" 
      }
    }
  }

  let view = switch state.route {
    | Home => <Home></Home>
    | ElectionNew => <ElectionNew></ElectionNew>
    | ElectionBooth(_id) => <ElectionBooth></ElectionBooth>
    | ElectionShow(_id) => <ElectionShow></ElectionShow>
    | ElectionResult(_id) => <ElectionResult></ElectionResult>
  }

  <PaperProvider>
    <State.StateContext.Provider value=state>
      <State.DispatchContext.Provider value=dispatch>
        <SafeAreaView style=X.styles["layout"]>
          <Appbar.Header>
            {if state.route != Route.Home {
              <>
                <Appbar.BackAction onPress={_ => dispatch(Navigate(Route.Home))} />
                <Appbar.Content title={title -> React.string} />
                {
                  switch state.route {
                  | ElectionBooth(id) 
                  | ElectionShow(id)
                  | ElectionResult(id) => {
                    <>
                      <Appbar.Action icon=Icon.name("menu") onPress={_ => setVisibleMenu(_ => true)}></Appbar.Action>
                      //<Menu
                      //  visible={visibleMenu}
                      //  onDismiss={setVisibleMenu(_ => false)}
                      //  anchor={<Button onPress={setVisibleMenu(_ => true)}>Show menu</Button>}>
                      //  <Menu.Item onPress={_ => {()}} title="Item 1" />
                      //  <Menu.Item onPress={_ => {()}} title="Item 2" />
                      //  <Divider />
                      //  <Menu.Item onPress={_ => {()}} title="Item 3" />
                      //</Menu>
                    </>
                  }
                  | __ => <></>
                  }
                }
              </>
            } else {
              <>
                <Appbar.Content title={title -> React.string} style=X.styles["pad-left"] />
              </>
            }}
          </Appbar.Header>
          {view}
        </SafeAreaView>
      </State.DispatchContext.Provider>
    </State.StateContext.Provider>
  </PaperProvider>
}