@react.component
let make = (~election:Election.t) => {
  let { t } = ReactI18next.useTranslation()

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

  let choices = Election.choices(election)
  let maxValue = Array.reduce(data, 0, (v1, v2) => (v1 > v2) ? v1 : v2)

  let question = switch Election.description(election) {
  | "" => t(."election.new.question")
  | question => question
  }

  <>
    <ElectionHeader election section=#result />

    <View style=S.questionBox>
      <S.Section title=question />
      <S.Row>
      {
        Array.mapWithIndex(data, (i, value) => {
          let color = Option.getWithDefault(colors[i],
            Color.rgb(~r=128,~g=128,~b=128))
          let ratio = Int.toFloat(value) /. Int.toFloat(maxValue)
          let choiceName = choices[i]->Option.getExn
          <S.Col key=(i->Int.toString)>
            <ReactNativeSvg.Svg style=Style.viewStyle(
              ~width=20.0->Style.dp,
              ~height=((100.0 *. ratio)->Style.dp),
              ~alignSelf=#center,
              ~marginTop=50.0->Style.dp,
              ~marginBottom=10.0->Style.dp,
              ~paddingTop=((100.0 *. (1. -. ratio))->Style.dp),
              ())>
              <ReactNativeSvg.Rect
                fill=color
                width=(20.0->Style.dp)
                height=((100.0 *. ratio)->Style.dp)
                />
            </ReactNativeSvg.Svg>
            <Text style=Style.textStyle(~color, ~alignSelf=#center, ())>
              { `${choiceName} (${value->Int.toString})` -> React.string }
            </Text>
          </S.Col>
        }) -> React.array
      }
      </S.Row>
    </View>
  </>
}

