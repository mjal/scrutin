@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, _) = StateContext.use()

  let electionUrl = `${URL.base_url}/elections/${electionId}/result`
  // NOTE: We have to use election.previousId here.
  // At the moment publishing the tally create a new election object with previousId set to the original election owning the ballots. This may change.
  let nbVotes = state
    ->State.getElectionValidBallots(Option.getExn(election.previousId))
    ->Array.length

  let data = switch election.result {
  | Some(result) => Belenios.Election.scores(result)
  | None => []
  }

  let colors =
    [(229, 193, 189), (123, 158, 135), (94, 116, 127), (210, 208, 186)]->Array.map(((r, g, b)) =>
      Color.rgb(~r, ~g, ~b)
    )

  let choices = Election.choices(election)
  let maxValue = Array.reduce(data, 0, (v1, v2) => v1 > v2 ? v1 : v2)

  <>
    <ElectionHeader election section=#result />
    <View style=S.questionBox>
      {switch Election.description(election) {
      | "" => <> </>
      | question => <S.Section title=question />
      }}
      <S.Section title={`${nbVotes->Int.toString} votants`} />
      <S.Row>
        {Array.mapWithIndex(data, (i, value) => {
          let color = Option.getWithDefault(colors[i], Color.rgb(~r=128, ~g=128, ~b=128))
          let ratio = Int.toFloat(value) /. Int.toFloat(maxValue)
          let ratio = Js.Float.isNaN(ratio) ? 0.0 : ratio
          let choiceName = choices[i]->Option.getExn
          <S.Col key={i->Int.toString}>
            <ReactNativeSvg.Svg
              style={Style.viewStyle(
                ~width=20.0->Style.dp,
                ~height=(100.0 *. ratio)->Style.dp,
                ~alignSelf=#center,
                ~marginTop=50.0->Style.dp,
                ~marginBottom=10.0->Style.dp,
                ~paddingTop=(100.0 *. (1. -. ratio))->Style.dp,
                (),
              )}>
              <ReactNativeSvg.Rect
                fill=color width={20.0->Style.dp} height={(100.0 *. ratio)->Style.dp}
              />
            </ReactNativeSvg.Svg>
            <Text style={Style.textStyle(~color, ~alignSelf=#center, ())}>
              {`${choiceName} (${value->Int.toString})`->React.string}
            </Text>
          </S.Col>
        })->React.array}
      </S.Row>
    </View>
    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <S.TextInput onChangeText={_ => ()} value=electionUrl />
    </View>
    <CopyButton text=electionUrl />
  </>
}
