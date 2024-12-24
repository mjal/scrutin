@react.component
let make = (~setup: Setup.t, ~electionId) => {
  let election = setup.election
  let (_state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")
  let (ballots, setBallots) = React.useState(_ => [])

  React.useEffect0(() => {
    (async () => {
      let response = await Webapi.Fetch.fetch(`${URL.bbs_url}/${election.uuid}/ballots`)
      switch Webapi.Fetch.Response.ok(response) { 
      | false =>
        Js.log("Can't find ballots")
      | true =>
        let json = await Webapi.Fetch.Response.json(response)
        Js.log(json) // Needed for next line
        let ballots: array<Ballot.t> = %raw(`json.ballots`)
        setBallots(_ => ballots)
        Js.log(ballots)
      }
    })()
    ->ignore
    None
  })

  let tally = _ => {
    Js.log(passphrase)
    let bigIntOfString = %raw(`
      function (s) {
        return BigInt('0x'+s);
      }
    `);
    let x = bigIntOfString(passphrase)
    Js.log(x)

    Js.log(election)
    Js.log(ballots)

    // TODO: Compute encrypted tally


    // TODO: Compute partial decryptions (skip proofs ?)
    // (5 points)

    // TODO: Compute result by bruteforcing decrypted values
    // (5 points)
    ()
  }

  <>
    <ElectionHeader election />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <Title>
      { "Entrer votre clé de gardien" -> React.string }
    </Title>

    <S.TextInput
      value=passphrase
      onChangeText={text => setPassphrase(_ => text)}
    />

    <S.Button
      title="Dépouiller"
      onPress=tally
    />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.Button
      title="Retour"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId}))
      }
    />
  </>
}
