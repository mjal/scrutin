module Election = {
  // ---
  // #### Election.create
  // Create a new election
  let create = (
    // **name**: The name of the election
    ~name : string,
    // **desc**: A description of the election
    ~desc : string,
    // **choices**: The options we can choose from
    ~choices : array<string>
    // ---
  ) => {
    (state: State.t, dispatch) => {
      // Select the first identity we own<br />
      // If we don't have any, create a new one
      let identity = switch Array.get(state.ids, 0) {
      | Some(identity) => identity
      | None =>
        let identity = Identity.make()
        dispatch(StateMsg.Identity_Add(identity))
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
      dispatch(StateMsg.Transaction_Add_With_Broadcast(transaction))
  
      // Store the trustee private key
      dispatch(StateMsg.Trustee_Add(trustee))
  
      // Go the election page
      dispatch(StateMsg.Navigate(Election_Show(transaction.contentHash)))
    }
  }

  // ---
  // #### Election.tally
  // Compute the result of an election, with help of the trustees keys
  let tally = (
    // **electionEventHash**: The transaction hash of the election to tally
    ~electionEventHash : string
    // ---
  ) => {
    (state: State.t, _dispatch) => {
      // Get the election from cache
      let election = Map.String.getExn(state.cached_elections,
        electionEventHash)

      // Casting value (to remove)
      let params = Belenios.Election.parse(election.params)
      let trustees = Belenios.Trustees.of_str(election.trustees)

      // Fetching the election private key from local storage
      let trustee = Array.getBy(state.trustees, (trustee) => {
        Belenios.Trustees.pubkey(trustees) ==
        Belenios.Trustees.pubkey(trustee.trustees)
      })
      let privkey = Option.getExn(trustee).privkey

      // Select the relevents ballots <br />
      let ballots =
        state.txs
        -> Array.keep((tx) => tx.type_ == #ballot)
        -> Array.keep((tx) => {
          let ballot = Transaction.SignedBallot.unwrap(tx)
          ballot.electionTx == electionEventHash
        })

      // Get the actual ballot content when filled <br />
      // TODO:Only take the latest from the chain
      let ciphertexts =
        ballots
        -> Array.map(Transaction.SignedBallot.unwrap)
        -> Array.map((ballot) => ballot.ciphertext)
        -> Array.keep((ciphertext) => Option.getWithDefault(ciphertext, "") != "")
        -> Array.map((ciphertext) => Belenios.Ballot.of_str(Option.getExn(ciphertext)))

      // HACK: Fetch the public creds stored in the ballots.
      // We don't need this but it is needed for Belenios.
      // (for every ballot we generate a new private credential)
      let pubcreds =
        ballots
        -> Array.map(Transaction.SignedBallot.unwrap)
        -> Array.map((ballot) => ballot.pubcred)
        -> Array.map((pubcred) => Option.getWithDefault(pubcred, ""))
        -> Array.keep((pubcred) => pubcred != "")

      let (a, b) = Belenios.Election.decrypt(params, ciphertexts, trustees, pubcreds, privkey)
      let _res = Belenios.Election.result(params, ciphertexts, trustees, pubcreds, a, b)
    }
  }
}

module Ballot = {
  // ---
  // #### Ballot.emit
  // TODO: Extract from Election_Show.res
  let emit = (
  ) => {
    // ---
    (_state, _dispatch) => {
      // Nothing for now
      None
    }
  }

  // ---
  // #### Ballot.vote
  // Cast a vote
  let vote = (
    // **ballot**: TODO
    ~ballot: Ballot.t,
    // **choice**: The selected option.<br />
    // Options are indexed starting at 0 to (nbChoices - 1)
    ~choice: option<int>,
    // **nbChoices**: The number of options available.<br />
    // This is also the upper bound to **choice**
    ~nbChoices: int
  ) => {
    // ---
    (state: State.t, dispatch) => {
      // Transform the choice index to an array of 0 and 1 for every options
      let selection =
        Array.make(nbChoices, 0)
        -> Array.mapWithIndex((i, _e) => { choice == Some(i) ? 1 : 0 })

      // Fetch the election from cache
      let election = Map.String.getExn(state.cached_elections,
        ballot.electionTx)

      // Create a ballot expressing that choice
      let ballot = Ballot.make(ballot, election, selection)

      // Lookup for the voter identity in the cache
      let owner = Array.getBy(state.ids, (id) => {
        ballot.voterPublicKey == id.hexPublicKey
      }) -> Option.getExn

      // Wrap it into a transaction
      let tx = Transaction.SignedBallot.make(ballot, owner)

      // Add the new transaction<br />
      dispatch(StateMsg.Transaction_Add_With_Broadcast(tx))

      // Go the ballot page
      dispatch(Navigate(Election_Show(ballot.electionTx)))
    }
  }
}
