@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let index = switch state.route {
    | Election_Index    => 0
    | Identity_Index    => 1
    | Trustee_Index     => 2
    | Event_Index       => 3
    | _ => 0
  }

  <BottomNavigation
    onIndexChange={i => {
        switch i {
        | 0 => dispatch(Navigate(Election_Index))
        | 1 => dispatch(Navigate(Identity_Index))
        | 2 => dispatch(Navigate(Trustee_Index))
        | 3 => dispatch(Navigate(Event_Index))
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
