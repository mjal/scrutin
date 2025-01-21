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

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~lineHeight=40.0, ~fontWeight=Style.FontWeight._900, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

    <Text style=Style.textStyle(~color=Color.grey, ())>
      {
        let nBallots = Int.toString(Array.length(electionData.ballots))
        `Nombre de votes enregistrés: ${nBallots}`->React.string
      }
    </Text>

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

    {Array.mapWithIndex(election.questions, (i, question) => {
      let row = Array.getExn(result, i)
      let total = Array.reduce(row, 0, (a, b) => a + b)
      let cumulativeSum = (grades) => {
        Array.mapWithIndex(grades, (i, _value) =>
          grades
          ->Array.slice(~offset=0, ~len=i + 1)
          ->Array.reduce(0, (a, b) => a + b)
        )
      }

      let cumulativeGrades = cumulativeSum(row)
      let medianIndex = Array.length(row) - Array.length(cumulativeGrades->Array.keep((x) => Int.toFloat(x) > Int.toFloat(total) /. 2.))
      let grade = Option.getWithDefault(Array.get(Election.grades, medianIndex), "Undefined")

      <View key={Int.toString(i)}>
        <Text style=Style.textStyle(~fontSize=30.0, ())>
          { `${question.question} (${grade})` -> React.string } 
        </Text>

        <View style=Style.viewStyle(~position=#relative, ~marginBottom=15.0->Style.dp, ~height=24.0->Style.dp, ~flexDirection=#row, ~alignItems=#center, ())>
        {
          Array.mapWithIndex(question.answers, (j, grade) => {
            let count = Array.getExn(row, j)
            let pct = Int.toFloat(count) /. Int.toFloat(total)

            // Color gradiant, adding some color anyway
            let min = 0xff / 5
            let r = Float.toInt(255. /. Int.toFloat(Array.length(row))) * j * 8/10 + min
            let g = (0xff - r) * 8/10 + min
            let color = Color.rgb(~r, ~g, ~b=r/2)

            if count >= 1 {
              <View style=Style.viewStyle(~flex=pct, ~position=#relative, ~height=24.0->Style.dp, ()) key=Int.toString(j)>
                <View style=Style.viewStyle(~width=100.0->Style.pct, ~position=#absolute, ~height=24.0->Style.dp, ())>
                  <ProgressBar progress=100.0 color style=Style.viewStyle(~height=24.0->Style.dp, ()) />
                </View>

                <View style=Style.viewStyle(~width=100.0->Style.pct, ~position=#absolute, ~zIndex=1,
                  ~alignItems=#center,
                  ~justifyContent=#center,
                  ~marginTop=6.0->Style.dp,
                ())>
                  <Text style=Style.textStyle(~fontSize=12.0, ())>
                    {grade->React.string}
                  </Text>
                </View>
              </View>
            } else {
              React.null
            }
          }) -> React.array
        }
        </View>
        <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />
      </View>
    })->React.array}
  </>
}
