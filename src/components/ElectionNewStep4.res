@react.component
let make = () => {
  let {t} = ReactI18next.useTranslation()
  let (_state, dispatch) = StateContext.use()

  let words = Array.init(12, _ => {
    let index = Sjcl.BitArray.extract(Sjcl.Random.randomWords(1),0,31)
    let index = mod(index, 2048)
    Array.getExn(Wordlist.english, index)
  })

  let mnemonic = Js.Array.joinWith(" ", words)
  let hash = Sjcl.Sha256.hash(mnemonic)
  let privkey = Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))
  let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
  let trustee = Trustee.fromJSON(serializedTrustee)
  let trustees = [trustee]

  let (a, b) = trustee
  Js.log(Point.serialize(b.public_key))

  <>
    <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
      { "Sauvegardez précieusement le mot de passe qui permet de cloturer l'urne." -> React.string }
    </Text>

    <Text style={S.flatten([S.title, Style.viewStyle(~margin=10.0->Style.dp, ())])}>
      { "Sur du papier, dans un gestionnaire de mot de passe, dans une messagerie chiffrée, dans un fichier..." -> React.string }
    </Text>

    <Title style=Style.textStyle(~fontSize=20.0, ~color=Color.green, ())>
      { mnemonic -> React.string }
    </Title>

    <Text style={S.flatten([S.title, Style.viewStyle(~margin=10.0->Style.dp, ())])}>
      { "Vous pouvez aussi la télécharger en cliquant ici (TODO)" -> React.string }
    </Text>

    <S.Button
      title={t(. "election.new.next")}
      onPress={ _ => dispatch(CreateOpenElection(trustees)) }
      />
  </>
}
