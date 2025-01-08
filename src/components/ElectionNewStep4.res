@react.component
let make = () => {
  let {t} = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()
  let (loading, setLoading) = React.useState(() => false)

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

  let (_a, b) = trustee
  Js.log(Point.serialize(b.public_key))

  let { title, description, choices } = state.newElection
  let question : QuestionH.t =  {
    question: "Question",
    answers: choices,
    min: 1,
    max: 1
  }
  let election = Election.create(title, description, trustees, [question])
  let election = {...election, unrestricted: (state.newElection.mode == State.Open)}

  let setup : Setup.t = {
    election,
    trustees,
    credentials: []
  }

  if loading {
    <>
      <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
        { "Chargement..." -> React.string }
      </Text>
    </>
  } else {
    <>
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
              download(mnemonic, "election-password.txt")
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
        onPress={ _ => {
          dispatch(CreateOpenElection(setup))
          setLoading(_=>true)
        }}
        />
    </>
  }
}
