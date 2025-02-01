@react.component
let make = (~electionData: ElectionData.t) => {
  let _ = (electionData)
  let { setup, result } = electionData
  let result = Option.getExn(result).result
  let { election } = setup

  <>
    <Header title="Résultats de l'élection" />

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

    <S.Container>

      <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~lineHeight=40.0, ~fontWeight=Style.FontWeight._900, ())>
        { `${election.name}`->React.string }
      </Title>

      <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

      <Text style=Style.textStyle(~color=Color.grey, ())>
        {
          let ballots = electionData.ballots
            ->Array.map(b => (b.credential, b))
            ->Js.Dict.fromArray
            ->Js.Dict.values
          let nBallots = Int.toString(Array.length(ballots))
          `Nombre de votes enregistrés: ${nBallots}`->React.string
        }
      </Text>

      <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />

      {Array.mapWithIndex(election.questions, (i, question) => {
        <View key={Int.toString(i)}>
          <Text style=Style.textStyle(~fontSize=30.0, ())>
            { question.question -> React.string }
          </Text>
        {
          let row = Array.getExn(result, i)
          let total = Array.reduce(row, 0, (a, b) => a + b)
          let max = Array.reduce(row, 0, (a, b) => a > b ? a : b)

          {Array.mapWithIndex(question.answers, (j, name) => {
            let count = Array.getExn(row, j)
            let progress = Int.toFloat(count) /. Int.toFloat(total)

            <View
              style=Style.viewStyle(~marginBottom=30.0->Style.dp, ())
              key={Int.toString(i) ++ "-" ++ Int.toString(j)} >
              <Text style=Style.textStyle(~fontSize=20.0, ())>
                { name -> React.string }
              </Text>
              <View style=Style.viewStyle(~position=#relative, ~marginBottom=15.0->Style.dp, ())>
                {
                  let style = Style.viewStyle(~zIndex=2, ~position=#absolute, ~height=24.0->Style.dp, ())
                  let color = if count == max {
                    Color.rgb(~r=0x23, ~g=0xb1, ~b=0x29)
                  } else {
                    Color.rgb(~r=0x67, ~g=0x50, ~b=0xa4)
                  }
                  <ProgressBar style progress color />
                }
                {
                  let container = Style.viewStyle(
                    ~zIndex=1,
                    ~position=#absolute,
                    ~margin=5.0->Style.dp,
                    ~width=100.0->Style.pct,
                    ())
                  let row = Style.viewStyle(~flexDirection=#row, ~justifyContent=#"space-between", ~width=98.5->Style.pct, ())
                  <View style=container>
                    <View style=row>
                      <Text style=Style.textStyle(~color=(if count == 0 { Color.black } else { Color.white }), ()) >
                        { `${Int.toString(count)} / ${Int.toString(total)}` -> React.string }
                      </Text>
                      <Text style=Style.textStyle(~color=Color.grey, ())>
                        { (Float.toString(100. *. progress) ++ "%") -> React.string }
                      </Text>
                    </View>
                  </View>
                }
              </View>
            </View>
          })->React.array}
        }
        <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ()) />
        </View>
      })->React.array}
    </S.Container>
  </>
}
