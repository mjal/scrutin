@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()
  let election = State.getElectionExn(state, electionId)

  let data = switch election.result {
  | Some(result) => Belenios.Election.scores(result)
  | None => []
  }

  let colors = [
    (229, 193, 189),
    (123, 158, 135),
    (94,  116, 127),
    (210, 208, 186)
  ] -> Array.map(((r,g,b)) => Color.rgb(~r,~g,~b))

  let pieData = Array.mapWithIndex(data, (i, e) => {
    let color = Array.get(colors, i) -> Option.getWithDefault(Color.grey)
    PieChart.Datum.make(~value=e, ~key=j`pie-$e`, ~color)
  })

  let choiceList =
    Election.choices(election)
    -> Array.mapWithIndex((i, name) => {
      let color = Array.get(colors, i) -> Option.getWithDefault(Color.grey)
      let count = Array.getExn(data, i)

      <List.Item title=j`$name ($count)` key=Int.toString(i)
        titleStyle=Style.textStyle(~color,())
      />
    }) -> React.array

  let pieStyle = Style.viewStyle(~height=Style.dp(200.0), ())

  <X.Row>
    <X.Col>
      <PieChart style=pieStyle data=pieData />
    </X.Col>
    <X.Col>
      { choiceList }
    </X.Col>
  </X.Row>
}

