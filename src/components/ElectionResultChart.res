@react.component
let make = (~electionId) => {
  let (state, _) = StateContext.use()
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

  let _choiceList =
    Election.choices(election)
    -> Array.mapWithIndex((i, name) => {
      let color = Array.get(colors, i) -> Option.getWithDefault(Color.grey)
      let count = Array.getExn(data, i)

      <List.Item title=`${name} (${count->Int.toString})` key=Int.toString(i)
        titleStyle=Style.textStyle(~color,())
      />
    }) -> React.array

  <S.Row>
  {
    let ratios = [1.0,0.5,0.3]
    Array.map([0,1,2], (i) => {
      let color = Option.getExn(colors[i])
      let ratio = Option.getExn(ratios[i])
      <S.Col key=(i->Int.toString)>
        <ReactNativeSvg.Svg style=Style.viewStyle(~width=10.0->Style.dp, ~alignSelf=#center,())>
          <ReactNativeSvg.Rect
            fill=color
            width=(10.0->Style.dp)
            height=((100.0 *. ratio)->Style.dp)
            />
        </ReactNativeSvg.Svg>
        <Text style=Style.textStyle(~color, ~alignSelf=#center, ())>{ "Choice name (n)" -> React.string }</Text>
      </S.Col>
    }) -> React.array
  }
  </S.Row>
}

