module Election = {
  // ---
  // #### Election.create
  // Create a new election
  let create = (
    // **name**: The name of the election
    ~name: string,
    // **desc**: A description of the election (optional)
    ~desc: string,
    // **choices**: The options we can choose from
    ~choices: array<string>,
  ) => {
    // ---

    (state: State.t, dispatch) => {
      // Select the first identity we own<br />
      // If we don't have any, create a new one
      let admin = switch state.accounts[0] {
      | Some(account) => account
      | None =>
        let account = Account.make()
        dispatch(StateMsg.Account_Add(account))
        account
      }

      // Generate a single trustee for now
      let trustee = Trustee.make()
      let trustees = trustee.trustees

      // Store the trustee private key
      dispatch(StateMsg.Trustee_Add(trustee))

      // Create an election
      let params = Belenios.Election._create(~name, ~description=desc,
        ~choices, ~trustees)

      let election : Election.t = {
        electionId: None,
        adminIds: [admin.userId],
        voterIds: [],
        params,
        trustees: Belenios.Trustees.to_str(trustees),
        pda: None, pdb: None, result: None
      }

      // wrap it in an event
      let event = Event_.ElectionInit.create(election, admin)

      // Add the new event<br />
      dispatch(StateMsg.Event_Add_With_Broadcast(event))

      // Go the election page
      dispatch(StateMsg.Navigate(list{"elections", event.cid}))
    }
  }

  // ---
  // #### Election.tally
  // Compute the result of an election, with help of the trustees keys
  let tally = (
    // **electionId**: The election to tally
    ~electionId: string,
  ) => {
    // ---

    (state: State.t, dispatch) => {
      // Get the election from cache
      let election = Map.String.getExn(state.elections, electionId)

      // Casting values (to remove)
      let params = Belenios.Election.parse(election.params)
      let trustees = Belenios.Trustees.of_str(election.trustees)

      // Fetching the election private key from local storage
      let trustee = Array.getBy(state.trustees, trustee => {
        Belenios.Trustees.pubkey(trustees) == Belenios.Trustees.pubkey(trustee.trustees)
      })
      let privkey = Option.getExn(trustee).privkey

      let ballots =
        state.ballots
        ->Array.keep((ballot) => ballot.electionId == electionId)

      let ciphertexts =
        ballots
        ->Array.map(ballot => ballot.ciphertext)
        ->Array.map(Belenios.Ballot.of_str)

      let pubcreds =
        ballots
        ->Array.map(ballot => ballot.pubcred)

      let (a, b) = Belenios.Election.decrypt(params, ciphertexts, trustees, pubcreds, privkey)
      let result = Belenios.Election.result(params, ciphertexts, trustees, pubcreds, a, b)

      // Lookup for the admin identity
      let admin = state->State.getElectionAdmin(election)

      let ev = Event_.ElectionTally.create({
        electionId,
        pda: Belenios.PartialDecryption.to_s1(a),
        pdb: Belenios.PartialDecryption.to_s2(b),
        result
      }, admin)

      dispatch(StateMsg.Event_Add_With_Broadcast(ev))
    }
  }
}

module Ballot = {
  // ---
  // #### Ballot.vote
  // Cast a vote
  let vote = (
    // **electionId** (election.originId || electionEvent.cid)
    ~electionId: string,
    ~voter: Account.t,
    // **choice**: The selected option.<br />
    // Options are indexed starting at 0 to (nbChoices - 1)
    ~choice: option<int>,
    // **nbChoices**: The number of options available.<br />
    // This is also the upper bound to **choice**
    ~nbChoices: int,
  ) => {
    // ---
    (state: State.t, dispatch) => {
      let election = Map.String.getExn(state.elections, electionId)
      // Transform the choice index to an array of 0 and 1 for every options
      let selection =
        Array.make(nbChoices, 0)
        ->Array.mapWithIndex((i, _value) => {choice == Some(i) ? 1 : 0})

      let ballot = Ballot.make(
        ~election,
        ~electionId,
        ~voterId=voter.userId,
        ~selection
      )

      let ev = Event_.ElectionBallot.create(ballot, voter)
      dispatch(StateMsg.Event_Add_With_Broadcast(ev))
    }
  }
}
