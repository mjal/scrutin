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
      { "Voici votre clé de gardien." -> React.string }
    </Title>

    <Title style=Style.textStyle(~fontSize=20.0, ())>
      { hexPrivkey -> React.string }
    </Title>

    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "Notez la, vous en aurez besoin pour cloturer l'élection." -> React.string }
    </Title>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
}
