@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(Action.Init)
    None
  })

  <Layout state dispatch>

    <Header />

    { switch state.route {
    | Home_Elections
    | Home_Identities
    | Home_Transactions
    => <Home />
    | Election_New => <Election_New />
    | _ => <Text>{"Unknown route"->React.string}</Text>
    } }

    /*
    {switch state.route {
    | Home => <Home />

    | ElectionNew => <ElectionNew />
    | ElectionBooth(_uuid)
    | ElectionResult(_uuid)
    | ElectionShow(_uuid) => <ElectionShow />

    | User_Register => <User_Register />
    | User_Register_Confirm(_email, _secret) => <User_Register_Confirm />
    | User_Profile => <User_Profile />
    | Admin_User_Show(user) =>  <Admin_User_Show user />
    }}
    */

    <Navigation />
  </Layout>
}
