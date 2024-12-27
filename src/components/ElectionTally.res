type tt = { ballot: string }

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

        // FIX: Ballots are wrongs
        let ballots: array<tt> = %raw(`json.ballots`)
        let ballots: array<Ballot.t> = Array.map(ballots, (b) => Obj.magic(Js.Json.parseExn(b.ballot)))
        setBallots(_ => ballots)
        Js.log(ballots)
      }
    })()
    ->ignore
    None
  })

  let tally = _ => {
    let bigIntOfString = %raw(`
      function (s) {
        return BigInt('0x'+s);
      }
    `);
    let x = bigIntOfString(passphrase)

    // Add credentials to setup
    let credentials = Array.map(ballots, (b) => {
      b.credential
    })
    let setup = {
      ...setup,
      credentials
    }

    let et = EncryptedTally.generate(setup, ballots)
    Js.log(et)

    let pd = PartialDecryption.generate(setup, et, 1, x);
    let pds = [pd]
    Js.log(pd)

    let result = Result_.generate(setup, et, pds)
    Js.log(result)
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
      disabled=(passphrase == "")
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
