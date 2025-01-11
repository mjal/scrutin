@react.component
let make = (~electionData: ElectionData.t) => {
  let (_state, dispatch) = StateContext.use()
  let { setup } = electionData
  let election = setup.election


  React.useEffect1(() => {
    let uuid = setup.election.uuid

    dispatch(StateMsg.ElectionFetch(uuid))
    let intervalId = Js.Global.setInterval(() => {
      dispatch(StateMsg.ElectionFetch(uuid))
    }, 5000)

    Some(() => Js.Global.clearInterval(intervalId))
  }, [])

  <>
    <ElectionHeader election />

    //<View>
    //  <ElectionShowChoices election />
    //</View>

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ())>
    </View>

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=30.0, ())>
      { `${election.name}`->React.string }
    </Title>

    //<Badge size=40 style=Style.viewStyle(~margin=30.0->Style.dp, ())>
    //  //<Text>
    //    { `En cours`->React.string }
    //  //</Text>
    //</Badge>

    <Chip icon=Paper.Icon.name("information") mode=#outlined>
      { `Status: En cours`->React.string }
    </Chip>

    <Title>
      {
        let nBallots = Array.length(electionData.ballots)
        `${Int.toString(nBallots)} votes`->React.string 
      }
    </Title>

    <View style={Style.viewStyle(~height=30.0->Style.dp, ())} />

    //<S.Button
    //  title="Voter"
    //  onPress={_ =>
    //    dispatch(Navigate(list{"elections", electionId, "openbooth"}))
    //  }
    ///>

    //<S.Button
    //  title="Admin: dépouillement"
    //  onPress={_ =>
    //    dispatch(Navigate(list{"elections", electionId, "tally"}))
    //  }
    ///>
  </>
}
