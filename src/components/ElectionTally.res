module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

@react.component
let make = (~electionData: ElectionData.t) => {
  let { setup, ballots } = electionData
  let { election } = setup
  let (_state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")

  let passphrase2privkey = (passphrase) => {
    let words = Js.String.splitByRe(%re("/\s+/g"), String.trim(passphrase))
    let mnemonic = Js.Array.joinWith(" ", words)
    let hash = Sjcl.Sha256.hash(mnemonic)
    Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))
  }

  let verifyPrivkey = (privkey, electionTrustee: Trustee.PublicKey.t) => {
    let (_privkey, trustee) = Trustee.generateFromPriv(privkey)
    let (_a, b) = Trustee.parse(trustee)
    Point.serialize(electionTrustee.public_key) == Point.serialize(b.public_key)
  }

  let fetchPassword = async _ => {
    let res = await ReactNativeAsyncStorage.getItem(election.uuid)
    switch (Js.Null.toOption(res)) {
    | None => ()
    | Some(pass) => setPassphrase(_ => pass)
    }
  }
  fetchPassword()->ignore

  let tally = async _ => {
    let privkey = passphrase2privkey(passphrase)
    let (_type, trustee) = Array.getExn(electionData.setup.trustees, 0)
    if (!verifyPrivkey(privkey, trustee)) {
      Window.alert("Bad password")
    }

    // Add credentials to setup
    let credentials = Array.map(ballots, (b) => b.credential)
    let setup = {...electionData.setup, credentials }

    let et = EncryptedTally.generate(setup, ballots)
    let pd = PartialDecryption.generate(setup, et, 1, privkey);
    let pds = [pd]
    let result = Result_.generate(setup, et, pds)

    let obj : Js.Json.t = Obj.magic({
      "encryptedTally": EncryptedTally.serialize(et, election),
      "partialDecryptions": pds,
      "result": result
    })

    let _response = await X.put(`${URL.bbs_url}/${election.uuid}/result`, obj)

    dispatch(Navigate(list{"elections", election.uuid}))
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
