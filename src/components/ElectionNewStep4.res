@react.component
let make = () => {
  let {t} = ReactI18next.useTranslation()
  let (_state, dispatch) = StateContext.use()

  let (privkey, serializedTrustee) = Trustee.create()
  let trustee = Trustee.fromJSON(serializedTrustee)
  let trustees = [trustee]

  Js.log("privkey")
  Js.log(privkey)
  let bigIntToString = %raw(`
    function (n, radix) {
      return n.toString(radix)
    }
  `);
  let hexPrivkey = bigIntToString(privkey, 16)
  Js.log(hexPrivkey)
  Js.log("trustees")
  Js.log(trustees)

  let next = _ => {
    dispatch(CreateOpenElection(trustees))
  }

  let passwordOf = %raw(`
    function (s) {
      const bip39 = require('bip39')
      bip39.entropyToMnemonic
      const mnemonic = bip39.entropyToMnemonic('00000000000000000000000000000000')
      return s.toString(radix)
    }
  `);

  let getWord = %raw(`
    function (s) {
      const word = s & BigInt("0b11111111111")
      const rest = s << 11n
      return [word, rest]
    }
  `);

  let rest = privkey
  let a = 1

  for x in 1 to 24 {
    let _ = x
    let (w, rest) = getWord(rest)
    Js.log(w)
  }

  <>
    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Sauvegarder la clé pour ouvrir l'urne de l'élection." -> React.string }
    //</Title>

    //<View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Option 1: Télécharger la clé." -> React.string }
    //</Title>

    //<View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    //<S.Button
    //  title="Télécharger"
    //  onPress={_ => ()}
    //  />

    //<View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Option 2: Écrivez le code sur un papier." -> React.string }
    //</Title>

    //<View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "divide genuine capable" -> React.string }
    //</Title>
    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "mystery develop panel" -> React.string }
    //</Title>
    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "bicycle patrol fan" -> React.string }
    //</Title>
    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "cloud arrest amazing" -> React.string }
    //</Title>

    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Vous devez sauvegarder la clé de l'urne." -> React.string }
    //</Title>

    <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
      { "Sauvegardez précieusement le mot de passe pour cloturer l'urne." -> React.string }
    </Text>

    <Text style={S.flatten([S.title, Style.viewStyle(~margin=10.0->Style.dp, ())])}>
      { "Du plus au moins sécurisé: Sur du papier, dans un gestionnaire de mot de passe, dans une messagerie chiffrée, dans un fichier ou dans un mail..." -> React.string }
    </Text>

    <Title style=Style.textStyle(~fontSize=20.0, ())>
      { hexPrivkey -> React.string }
    </Title>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
}
