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
    {
      switch state.election.result {
      | Some(result) => {
        let results : results_t = parse_results(result)

        <DataTable>
          <DataTable.Header>
            <DataTable.Title>{"Candidat"->React.string}</DataTable.Title>
            <DataTable.Title numeric=true>{"Score (%)"->React.string}</DataTable.Title>
            <DataTable.Title numeric=true>{"Score (total)"->React.string}</DataTable.Title>
          </DataTable.Header>
          {
            Array.mapWithIndex(state.election.choices, (i, choice) => {
              <DataTable.Row key=(i->Int.toString)>
                <DataTable.Cell>{choice.name->React.string}</DataTable.Cell>
                <DataTable.Cell numeric=true>
                  {getResultN(results, i) -> Int.toString -> React.string}
                </DataTable.Cell>
                <DataTable.Cell numeric=true>
                  {getResultN(results, i) -> Int.toString -> React.string}
                </DataTable.Cell>
              </DataTable.Row>
            }) -> React.array
          }
        </DataTable>
      }
      | None => 
        <Text>{ "The election is not closed yet" -> React.string }</Text>
      }
    }
	</View>
}