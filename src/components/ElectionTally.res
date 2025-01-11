type tt = { ballot: string }

module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

@react.component
let make = (~electionData: ElectionData.t) => {
  let election = electionData.setup.election
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

  let tally = async _ => {
    Js.log(passphrase)

    let regex = %re("/\s+/g")
    let words = Js.String.splitByRe(regex, String.trim(passphrase))
    let mnemonic = Js.Array.joinWith(" ", words)
    let hash = Sjcl.Sha256.hash(mnemonic)
    let privkey = Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))

    let (_privkey, trustee) = Trustee.generateFromPriv(privkey)

    let trustee2 = Trustee.fromJSON(trustee)
    let (_a, b) = trustee2
    Js.log(Point.serialize(b.public_key))

    let (_type, trustee) = Array.getExn(electionData.setup.trustees, 0)
    Js.log(Point.serialize(trustee.public_key))

    // TODO: Use <Dialog />
    if (Point.serialize(trustee.public_key) == Point.serialize(b.public_key)) {
      Window.alert("Good password")
    } else {
      Window.alert("Bad password")
    }


    // Add credentials to setup
    let credentials = Array.map(ballots, (b) => b.credential)
    let setup = {
      ...electionData.setup,
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

    let obj : Js.Json.t = Obj.magic({
      "encryptedTally": EncryptedTally.serialize(et, election),
      "partialDecryptions": pds,
      "result": result
    })

    let _response = await X.put(`${URL.bbs_url}/${election.uuid}/result`, obj)

    // TODO: Send Result
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
      onPress= (_ => {
        tally()->ignore
      })
    />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.Button
      title="Retour"
      onPress={_ =>
        dispatch(Navigate(list{"elections", election.uuid}))
      }
    />
  </>
}
