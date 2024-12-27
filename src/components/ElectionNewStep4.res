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

  <>
    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "Sauvegarder la clé pour ouvrir l'urne de l'élection." -> React.string }
    </Title>

    <View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "Option 1: Télécharger la clé." -> React.string }
    </Title>

    <View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    <S.Button
      title="Télécharger"
      onPress={_ => ()}
      />

    <View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "Option 2: Écrivez le code sur un papier." -> React.string }
    </Title>

    <View style={Style.viewStyle(~marginTop=30.0->Style.dp, ())} />

    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "divide genuine capable" -> React.string }
    </Title>
    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "mystery develop panel" -> React.string }
    </Title>
    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "bicycle patrol fan" -> React.string }
    </Title>
    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "cloud arrest amazing" -> React.string }
    </Title>

    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Voici votre clé de gardien." -> React.string }
    //</Title>
    //<Title style=Style.textStyle(~fontSize=20.0, ())>
    //  { hexPrivkey -> React.string }
    //</Title>
    //<Title style=Style.textStyle(~fontSize=32.0, ())>
    //  { "Notez la, vous en aurez besoin pour cloturer l'élection." -> React.string }
    //</Title>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
}
