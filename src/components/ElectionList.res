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
              <Text style=styles["grey"]>{"Election sans nom"->rs}</Text>
            } else {
              <Text>{election.name->rs}</Text>
            }}
            <View style=shared_styles["separator"] />
          </View>
        )
        -> ra
      }
    </View>
  }
}