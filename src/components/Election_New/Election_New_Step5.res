@react.component
let make = (~state: Election_New_State.t, ~dispatch) => {
  let {t} = ReactI18next.useTranslation()
  let (_globalState, globalDispatch) = StateContext.use()
  let (loading, setLoading) = React.useState(() => false)
  let _ = dispatch

  let words = React.useMemo(() => {
    Array.init(12, _ => {
      let index = Sjcl.BitArray.extract(Sjcl.Random.randomWords(1),0,31)
      let index = mod(index, 2048)
      Array.getExn(Wordlist.english, index)
    })
  })
  let mnemonic = Js.Array.joinWith(" ", words)

  let hash = Sjcl.Sha256.hash(mnemonic)
  let privkey = Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))
  let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
  let trustee = Trustee.fromJSON(serializedTrustee)
  let trustees = [trustee]
  let description = ""
  let { title, questions } = state
  let election = React.useMemo(() => {
    Election.create(description, Option.getExn(title), trustees, questions)
  })
  let election = {...election, unrestricted: true}

  let create = async _ => {
    let setup : Setup.t = {
      election,
      trustees,
      credentials: []
    }

    let { election } = setup
    let obj : Js.Json.t = Obj.magic({"setup": Setup.serialize(setup)})
    let _response = await X.put(`${URL.bbs_url}/${election.uuid}`, obj)
    globalDispatch(StateMsg.Navigate(list{"elections", election.uuid}))
  }

  if loading {
    <>
      <Header title="Nouvelle élection" subtitle="5/5" />

      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { "Chargement..." -> React.string }
      </Text>
    </>
  } else {
    <>
      <Header title="Nouvelle élection" subtitle="4/5" />

      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { "Sauvegardez précieusement le mot de passe qui permet de cloturer l'urne." -> React.string }
      </Text>

      <Text style={S.flatten([S.title, Style.viewStyle(~margin=10.0->Style.dp, ())])}>
        { "Sur du papier, dans un gestionnaire de mot de passe, dans une messagerie chiffrée, dans un fichier..." -> React.string }
      </Text>

      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ~borderColor=Color.green, ~borderWidth=4.0, ())])}>
        { mnemonic -> React.string }
      </Text>

      <Text style={S.flatten([S.title, Style.viewStyle(~margin=10.0->Style.dp, ())])}>
        { "Vous pouvez aussi la télécharger en cliquant ici" -> React.string }
      </Text>

      <S.Button
        title={"Télécharger"}
        onPress={_ => {
          (async () => {
            if ReactNative.Platform.os == #web {
              let download = %raw(`function(content, filename) {
                  let blob = new Blob([content], {"type": "text/plain"})
                  let url = URL.createObjectURL(blob)
                  let a = document.createElement("a")
                  a.href = url
                  a.download = filename
                  a.click()
                  URL.revokeObjectURL(url)
                }`)
              download(mnemonic, `election-password-${election.uuid}.txt`)
            } else {
              let fileUri = FileSystem.documentDirectory ++ "example.json"
              await FileSystem.writeAsStringAsync(fileUri, mnemonic)
            }
          })() -> ignore
          ()
        }}
        />

      <Text style={S.flatten([S.title, Style.viewStyle(~marginTop=20.0->Style.dp, ())])}>
        { "Une fois le mot de passe sauvegardé, vous pouvez passer à la suite" -> React.string }
      </Text>

      <S.Button
        title={t(. "election.new.next")}
        onPress={ _ => create()->ignore }
        />
    </>
  }
}
