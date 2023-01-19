open ReactNative

let styles = {
  open Style
  StyleSheet.create({
    "grey": textStyle(~color="grey", ())
  })
}

@react.component
let make = () => {
  let (state, _dispatch) = State.useContextReducer()

  Js.log(state.elections)

  if state.elections_loading {
    <ActivityIndicator />
  } else {
    <View>
      {
        state.elections
        -> Js.Array2.map((election) =>
          <View>
            {
              Js.log(election.name)
              if election.name == "" {
              <Text style=styles["grey"]>{"Election sans nom" -> React.string}</Text>
            } else {
              <Text>{election.name -> React.string}</Text>
            }}
            <View style=X.styles["separator"] />
          </View>
        )
        -> React.array
      }
    </View>
  }
}