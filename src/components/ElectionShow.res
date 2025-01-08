@react.component
let make = (~electionData: ElectionData.t, ~electionId) => {
  let (_state, dispatch) = StateContext.use()
  let { setup } = electionData
  let election = setup.election


  React.useEffect1(() => {
    dispatch(StateMsg.ElectionFetch(electionId))

    let intervalId = Js.Global.setInterval(() => {
      dispatch(StateMsg.ElectionFetch(electionId))
    }, 5000)

    Some(() => Js.Global.clearInterval(intervalId))
  }, [])

  <>
    <ElectionHeader election />
    <View>
      <ElectionShowChoices election />
    </View>

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
