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
    Js.log(passphrase)

    let regex = %re("/\s+/g")
    let words = Js.String.splitByRe(regex, String.trim(passphrase))
    let mnemonic = Js.Array.joinWith(" ", words)
    let hash = Sjcl.Sha256.hash(mnemonic)
    let privkey = Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))

    let (_privkey, trustee) = Trustee.generateFromPriv(privkey)

    let trustee2 = Trustee.fromJSON(trustee)
    let (a, b) = trustee2
    Js.log(Point.serialize(b.public_key))

    // Add credentials to setup
    let credentials = Array.map(ballots, (b) => b.credential)
    let setup = {
      ...setup,
      trustees: [trustee2],
      credentials
    }

    let et = EncryptedTally.generate(setup, ballots)
    Js.log(et)

    let pd = PartialDecryption.generate(setup, et, 1, privkey);
    let pds = [pd]
    Js.log(setup)

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
