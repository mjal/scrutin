@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => [])
  //let (visibleChoice, setVisibleChoice) = React.useState(_ => false)
  //let (visibleVoter, setVisibleVoter) = React.useState(_ => false)

  let onSubmit = _ => {
    let identity = switch Array.get(state.ids, 0) {
    | Some(identity) => identity
    | None => {
      let identity = Identity.make()
      dispatch(Identity_Add(identity))
      identity
    }}
    let trustee  = Trustee.make()
    let election = Election.make(name, desc, choices,
      identity.hexPublicKey, trustee)
    let transaction = Transaction.SignedElection.make(election, identity)
    dispatch(Trustee_Add(trustee))
    dispatch(Transaction_Add(transaction))
    dispatch(Navigate(Election_Show(transaction.eventHash)))
  }

  <>
    <TextInput
      mode=#flat
      label="Nom de l'élection"
      testID="election-name"
			value=name
      onChangeText={text => setName(_ => text)}
    />

    <TextInput
      mode=#flat
      label="Description"
      testID="election-desc"
			value=desc
      onChangeText={text => setDesc(_ => text)}
    />

    <Election_New_ChoiceList choices setChoices />

    {
      switch Array.get(state.ids, 0) {
      | Some(user) =>
        <List.Item
          title="Owner"
          description=user.hexPublicKey />
      | None =>
        <List.Item
          title="Owner"
          description="No public key found" />
      }
    }
    //<Election_New_VoterList voters setVoters />

    <Button mode=#contained onPress=onSubmit>
      {"Create" -> React.string}
    </Button>
  </>
}
