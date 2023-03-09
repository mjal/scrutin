@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let index = switch state.route {
    | Home_Elections    => 0
    | Home_Identities   => 1
    | Home_Trustees     => 2
    | Home_Transactions => 3
    | _ => 0
  }

  <BottomNavigation
    onIndexChange={i => {
        switch i {
        | 0 => dispatch(Navigate(Home_Elections))
        | 1 => dispatch(Navigate(Home_Identities))
        | 2 => dispatch(Navigate(Home_Trustees))
        | 3 => dispatch(Navigate(Home_Transactions))
        | _ => ()
        }
    }}
    navigationState={
      "index": index,
      "routes": [
        {
          "key": "elections",
          "title": "Elections",
          "icon": "vote",
          "accessibilityLabel": None,
          "badge": None,
          "color": None,
          "testID": None
        },
        {
          "key": "identities",
          "title": "Identities",
          "icon": "account",
          "accessibilityLabel": None,
          "badge": None,
          "color": None,
          "testID": None
        },
        {
          "key": "trustees",
          "title": "Trustees",
          "icon": "thing",
          "accessibilityLabel": None,
          "badge": None,
          "color": None,
          "testID": None
        },
        {
          "key": "transactions",
          "title": "Transactions",
          "icon": "thing",
          "accessibilityLabel": None,
          "badge": None,
          "color": None,
          "testID": None
        },
      ]
    }
    renderScene = {(o) => <Text>{ o["route"]["title"] -> React.string} </Text>}
    //renderLabel = {(o) =>
    //  <List.Icon icon=Icon.name(o["route"]["icon"]) />
    //}
  >
  </BottomNavigation>
}
