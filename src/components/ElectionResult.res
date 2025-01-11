@react.component
let make = (~electionData: ElectionData.t) => {
  let _ = (electionData)
  let { setup, result } = electionData
  let result = Option.getExn(result).result
  let { election } = setup

  <>
    <Header title="Résultats de l'élection" />

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ())>
    </View>

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=30.0, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

    <Text style=Style.textStyle(~color=Color.grey, ())>
      { "Date de début: Non définie"->React.string }
    </Text>

    <Text style=Style.textStyle(~color=Color.grey, ())>
      { "Date de fin: Non définie"->React.string }
    </Text>

    <Text style=Style.textStyle(~color=Color.grey, ())>
      {
        let nBallots = Int.toString(Array.length(electionData.ballots))
        `Nombre de votes enregistrés: ${nBallots}`->React.string
      }
    </Text>

    {Array.mapWithIndex(election.questions, (i, question) => {
      <View key={Int.toString(i)}>
      {
        let row = Array.getExn(result, i)
        let total = Array.reduce(row, 0, (a, b) => a + b)
        {Array.mapWithIndex(question.answers, (j, name) => {
          let count = Array.getExn(row, j)

          <View key={Int.toString(i) ++ "-" ++ Int.toString(j)}>
            <Text>
              { name -> React.string }
            </Text>

            <View>
              <Text>
                { `${Int.toString(count)} / ${Int.toString(total)}` -> React.string }
              </Text>
            </View>
          </View>
        })->React.array}
      }
      </View>
    })->React.array}
  </>

/*
  let (state, _) = StateContext.use()

  let electionUrl = `${URL.base_url}/elections/${electionId}/result`

  let nbVotes =
    state.ballots
    ->Array.keep((ballot) => ballot.electionId == electionId)
    ->Array.length

  //let data = switch election.result {
  //| Some(result) => Belenios.Election.scores(result)
  //| None => []
  //}

  let colors =
    [(229, 193, 189), (123, 158, 135), (94, 116, 127), (210, 208, 186)]->Array.map(((r, g, b)) =>
      Color.rgb(~r, ~g, ~b)
    )

  let choices = [] // FIX: Election.choices(election)

  //let maxValue = Array.reduce(data, 0, (v1, v2) => v1 > v2 ? v1 : v2)

  <>
    <ElectionHeader election section=#result />
    <View style=S.questionBox>
      {switch election.description {
      | "" => <> </>
      | question => <S.Section title=question />
      }}
      <S.Section title={`${nbVotes->Int.toString} votants`} />
      <S.Row>
        {Array.mapWithIndex([]/*data*/, (i, value) => { // FIX: Use data
          let color = Option.getWithDefault(colors[i], Color.rgb(~r=128, ~g=128, ~b=128))
          let ratio = Int.toFloat(value) /. Int.toFloat(/*maxValue*/1) // FIX: Use maxValue
          let ratio = Js.Float.isNaN(ratio) ? 0.0 : ratio
          let ratio = Js.Math.max_float(ratio, 0.05)
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
*/
}
