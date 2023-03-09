module Election = {
  // #### Election.create
  let create = (
    // **name**: The name of the election
    ~name : string,
    // **desc**: A description of the election
    ~desc : string,
    // **choices**: The options we can choose from
    ~choices : array<string>
  ) => {
  
    (state: State.t, dispatch) => {
  
      // Select the first identity we own<br />
      // If we don't have any, create a new one
      let identity = switch Array.get(state.ids, 0) {
      | Some(identity) => identity
      | None =>
        let identity = Identity.make()
        dispatch(StateMutation.Identity_Add(identity))
        identity
      }
  
      // Generate a single trustee for now
      let trustee  = Trustee.make()
  
      // Generate the election
      let election = Election.make(name, desc, choices,
        identity.hexPublicKey, trustee)
  
      // wrap it in a transaction
      let transaction = Transaction.SignedElection.make(election, identity)
  
      // Add the new transaction<br />
      // TODO: Broadcast it
      dispatch(StateMutation.Transaction_Add(transaction))
  
      // Store the trustee private key
      dispatch(StateMutation.Trustee_Add(trustee))
  
      // Go the election page
      dispatch(StateMutation.Navigate(Election_Show(transaction.eventHash)))
    }
  }
}
