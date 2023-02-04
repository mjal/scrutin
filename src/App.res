// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative
open Paper

@module external belenios: 'a = "./belenios_jslib2"

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    if !state.init {
      Linking.getInitialURL()
      -> Promise.thenResolve(res => {
        let sUrl = res -> Js.Null.toOption -> Option.getWithDefault("")

        let url = URL.make(sUrl)
        let oResult = Js.Re.exec_(%re("/^\/elections\/(.*)/g"), URL.pathname(url))
        let capture = switch oResult {
        | Some(result) =>
          switch Js.Re.captures(result)[1] {
            | Some(str) => Js.toOption(str)
            | None => None
          }
        | None => None
        }

        switch capture {
          | Some(sId) => dispatch(Action.Navigate(ElectionBooth(sId -> Int.fromString -> Option.getWithDefault(0))))
          | None => ()
        }
      }) -> ignore

      dispatch(Action.Init)
    }

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
              </>
            } else {
              <Appbar.Content title={title -> React.string} style=X.styles["pad-left"] />
            }}
          </Appbar.Header>
          {view}
        </SafeAreaView>
      </State.DispatchContext.Provider>
    </State.StateContext.Provider>
  </PaperProvider>
}