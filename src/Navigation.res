@react.component
let make = () => {
  let (index, setIndex) = React.useState(_ => 0)

  <BottomNavigation
    onIndexChange={i => setIndex(_ => i)}
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
