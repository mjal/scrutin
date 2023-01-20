open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, _dispatch) = State.useContextReducer()

  <View>
    <List.Section title="Choices">
      {
        state.election.choices
        -> Js.Array2.map(choice => {
          <List.Item title=choice.name>
          </List.Item>
        })
        -> React.array
      }
    </List.Section>
    <Button mode=#contained onPress={_ => ()}>
      {"Voter" -> React.string}
    </Button>
  </View>
}