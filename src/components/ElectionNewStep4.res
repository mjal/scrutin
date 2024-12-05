@react.component
let make = () => {
  let {t} = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()

  let (privkey, serializedTrustee) = Sirona.Trustee.create()
  let trustee = Sirona.Trustee.fromJSON(serializedTrustee)
  let trustees = [trustee]

  let next = _ => {
    dispatch(CreateOpenElection(trustees))
  }

  <>
    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { "Here is your guardian private key. Keep it with care" -> React.string }
    </Title>

    <Title style=Style.textStyle(~fontSize=32.0, ())>
      { Int.toString(privkey) -> React.string }
    </Title>

    <S.Button
      title={t(. "election.new.next")}
      onPress=next
      />
  </>
}
