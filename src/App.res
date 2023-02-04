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
    | Home => "Scrutin"
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

  // TODO: Delete
  /*
  React.useEffect(() => {
    let (privkey, trustees) = Belenios.Trustees.create()
    Js.log(1)
    Js.log(privkey)
    Js.log(trustees)
    Js.log(2)
    let election = Belenios.Election.create("myelection", "amazing election2", ["Ok", "Not Ok"], trustees)
    let uuid = election->Belenios.Election.uuid
    let (pubcreds, privcreds) = Belenios.Credentials.create(uuid, 10)
    let cred = Array.getExn(privcreds, 0)
    Js.log(cred)
    Js.log(trustees)
    let ballot = Belenios.Election.vote(election, cred, [[1,0]], trustees)
    Js.log(ballot)
    let (a, b) = Belenios.Election.decrypt(election, [ballot], trustees, pubcreds, privkey)
    Js.log("=== Decryption ===")
    Js.log(a)
    Js.log(b)
    let res = Belenios.Election.result(election, [ballot], trustees, pubcreds, a, b)
    Js.log(res)
    None
  })
  */

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