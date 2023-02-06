open ReactNative
open! Paper

type results_t = { result: array<array<int>> }
@val external parse_results: (string) => results_t = "JSON.parse"

let getResultN = (results : results_t, i : int) : int => {
  Option.getExn(Option.getExn(results.result[0])[i])
}

@react.component
let make = () => {
  let (state, _dispatch) = Context.use()

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    {
      switch state.election.result {
      | Some(result) => {
        let results : results_t = parse_results(result)

        <List.Section title="Resultats">
        {
          Array.mapWithIndex(state.election.choices, (i, choice) => {
            <List.Item
              title=choice.name
              left={_ => <List.Icon icon=Icon.name("account") />}
              right={_ =>
                <Text>
                  {getResultN(results, i) -> Int.toString -> React.string}
                </Text>
              }
            />
          }) -> React.array
        } 
        </List.Section>
      }
      | None => 
        "The election is not closed yet" -> React.string
      }
    }
	</View>
}