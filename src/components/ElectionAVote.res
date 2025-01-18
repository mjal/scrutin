@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let (_, globalDispatch) = StateContext.use()
  let _ = (state, setState)
  let election = electionData.setup.election

  <>
    <Header title="A voté" />

    {
      open Style
      let viewStyle = viewStyle(~alignSelf=#center, ~margin=42.0->dp, ())
      let textStyle = textStyle(~fontSize=120.0, ())
      <View style=viewStyle>
        <Text style=textStyle>
          { "🎉" -> React.string }
        </Text>
      </View>
    }

    <Title style=Style.textStyle(~alignSelf=#center, ~color=Color.black, ~fontSize=60.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
      { "A voté" -> React.string }
    </Title>

    <Text style=Style.textStyle(~alignSelf=#center, ~fontSize=30.0, ~margin=30.0->Style.dp, ())>
      { "Votre vote a bien été pris en compte" -> React.string }
    </Text>

    <S.Button
      title="Retour à l'élection"
      onPress={_ => {
        globalDispatch(Navigate(list{"elections", election.uuid}))
      }}
    />
  </>
}


