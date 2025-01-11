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
    <Header title="Résultats de l'élection" />

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ())>
    </View>

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=30.0, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style=Style.viewStyle(~margin=20.0->Style.dp, ())>
      {
        switch electionData.result {
        | None =>
          <Chip icon=Paper.Icon.name("information") mode=#outlined>
            { `Status: En cours`->React.string }
          </Chip>
        | Some(_result) =>
          <Chip icon=Paper.Icon.name("information") mode=#outlined>
            { `Status: Finished`->React.string }
          </Chip>
        }
      }
    </View>

    <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
      { "Date de début: Non définie"->React.string }
    </Text>

    <Text style=Style.textStyle(~color=Color.black, ~fontWeight=Style.FontWeight.bold, ())>
      { "Date de fin: Non définie"->React.string }
    </Text>

    <Text>
      {
        let nCredentials = Int.toString(Array.length(setup.credentials))
        `Nombre de votants invités par email: ${nCredentials}`->React.string
      }
    </Text>

    <Text>
      {
        let nBallots = Int.toString(Array.length(electionData.ballots))
        `Nombre de votes enregistrés: ${nBallots}`->React.string
      }
    </Text>

    <View style={Style.viewStyle(~height=30.0->Style.dp, ())} />
  </>
}
