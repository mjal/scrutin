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

  let title = switch state.route {
    | Home => "Home"
    | Profile => "Profile"
    | ElectionNew => "Election > Nouvelle election"
    | _ => {
      if state.election.name != "" {
        "Election > " ++ state.election.name
      } else {
       "Election > Unamed election" 
      }
    }
  }

  let view = switch state.route {
    | Home => <Home></Home>
    | ElectionNew => <ElectionNew></ElectionNew>
    | ElectionBooth(_id)
    | ElectionResult(_id)
    | ElectionShow(_id) => <ElectionShow></ElectionShow>
    | Profile => <Profile></Profile>
  }

  <PaperProvider theme=Paper.ThemeProvider.Theme.make(~dark=true, ())>
    <Context.State.Provider value=state>
      <Context.Dispatch.Provider value=dispatch>
        <SafeAreaView style=X.styles["layout"]>
          <Appbar.Header>
            {if state.route != Route.Home {
              <>
                <Appbar.BackAction onPress={_ => dispatch(Navigate(Route.Home))} />
                <Appbar.Content title={title -> React.string} />
                {
                  switch state.route {
                  | ElectionBooth(_id) 
                  | ElectionShow(_id)
                  | ElectionResult(_id) => {
                    <>
                      <Appbar.Action icon=Icon.name("menu") onPress={_ => ()/*setVisibleMenu(_ => true)*/}></Appbar.Action>
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
      </Context.Dispatch.Provider>
    </Context.State.Provider>
  </PaperProvider>
}