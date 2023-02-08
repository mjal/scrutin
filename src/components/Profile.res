open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, _dispatch) = Context.use()

  let user_id = state.user -> Option.flatMap(user => user.id) -> Option.getWithDefault(0)

  <View style=X.styles["margin-x"]>
    <Title style=X.styles["title"]>{ "My elections (as administrator)" -> React.string }</Title>
    {
      Array.keep(state.elections, (election) => {
        election.administrator_id == user_id
      })
      -> Array.map((election) => {
        <Text key=(election.id->Int.toString)>{election.id -> Int.toString -> React.string} {election.name -> React.string}</Text>
      }) -> React.array
    }
    <Title style=X.styles["title"]>{ "My elections (as voter)" -> React.string }</Title>
    <Title style=X.styles["title"]>{ "TODO" -> React.string }</Title>
  </View>
}