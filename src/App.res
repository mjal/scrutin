// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative
open Paper

@module external belenios: 'a = "./belenios_jslib2"

@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  if !state.init {
    dispatch(Action.Init)
  }

  let title = switch state.route {
    | Home => "Home"
    | ElectionNew => "Nouvelle election"
    | _ => "Unknown"
  }

  let view = switch state.route {
    | Home => <Home></Home>
    | ElectionNew => <ElectionNew></ElectionNew>
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
        <SafeAreaView>
          <Appbar.Header>
            <Appbar.BackAction onPress={_ => dispatch(Navigate(Route.Home))} />
            <Appbar.Content title={title -> React.string} />
          </Appbar.Header>
          {view}
        </SafeAreaView>
      </State.DispatchContext.Provider>
    </State.StateContext.Provider>
  </PaperProvider>
}