@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let (_state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")
  let (_ballots, setBallots) = React.useState(_ => [])
  let (demoPlaintexts, setDemoPlaintexts) = React.useState(_ => [])

  React.useEffect0(() => {
    (async () => {
      let response = await Webapi.Fetch.fetch(`${URL.bbs_url}/${election.uuid}/ballots`)
      switch Webapi.Fetch.Response.ok(response) { 
      | false =>
        Js.log("Can't find ballots")
      | true =>
        let json = await Webapi.Fetch.Response.json(response)
        Js.log(json) // Needed for next line
        let ballots: array<Sirona.Ballot.t> = %raw(`json.ballots`)
        setBallots(_ => ballots)
        Js.log(ballots)
      }
    })()
    ->ignore
    None
  })

  let tally = _ => {
    let initial = Array.map(election.questions, (q) => {
      Array.make(Array.length(q.answers), 0)
    })
    let result = Array.reduce(demoPlaintexts, initial, (a, b) => {
      Array.zip(a,b)-> Array.map(((row1, row2)) =>
        Array.zip(row1,row2)->Array.map(((e1,e2)) => e1 + e2)
      )
    })
    Js.log(result)

    // TODO: Compute encrypted tally
    // (2 points: Extract multiply ballot logic in sirona)

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
