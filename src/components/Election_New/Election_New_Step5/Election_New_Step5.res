@react.component
let make = (~state: Election_New_State.t, ~setState) => {

  React.useEffect0(() => {
    let mnemonic = Mnemonic.generate()
    let privkey = Mnemonic.toPrivkey(mnemonic)
    let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
    let trustee = Trustee.parse(serializedTrustee)
    let trustees = [trustee]
    let { questions } = state
    let election = Election.create(state.desc, state.title, trustees, questions)

    // TODO: Pass directly as ?attr
    let access = Option.getWithDefault(state.access, #"open")
    let votingMethod = Option.getWithDefault(state.votingMethod, #uninominal)

    let election = {
      ...election,
      access,
      votingMethod,
      startDate: ?state.startDate,
      endDate: ?state.endDate,
    }

    setState(_ => {...state, mnemonic, election, trustees})
    None
  })

  <>
    <Header title="Nouvelle élection" subtitle="5/5" />
    { switch state.passwordPolicy {
    | None => <Election_New_Step5_Menu state setState />
    | Some(#file) => <Election_New_Step5_File state setState />
    | Some(#local) => <Election_New_Step5_Local state setState />
    | Some(#extern) => <Election_New_Step5_Extern state setState />
    } }
  </>
}
