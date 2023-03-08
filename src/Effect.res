let identities_fetch = (dispatch) => {
  Identity.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(Action.Identity_Add(id)))
  }) -> ignore
}

let identities_store = (ids) =>
  (_dispatch) => Identity.store_all(ids)

let identities_clear =
  (_dispatch) => Identity.clear()

let transactions_fetch = (dispatch) => {
  Transaction.fetch_all()
  -> Promise.thenResolve((txs) => {
    Array.map(txs, (tx) => dispatch(Action.Transaction_Add(tx)))
  }) -> ignore
}

let transactions_store = (txs) =>
  (_dispatch) => Transaction.store_all(txs)

let transactions_clear =
  (_dispatch) => Transaction.clear()

let cache_update = (tx : Transaction.t) =>
  (dispatch) => {
    switch tx.eventType {
    | "election" => dispatch(Action.Cache_Election_Add(tx.eventHash,
      Transaction.SignedElection.unwrap(tx)))
    | "ballot" => dispatch(Action.Cache_Ballot_Add(tx.eventHash,
      Transaction.SignedBallot.unwrap(tx)))
    | _ => Js.Exn.raiseError("Unknown transaction type")
    }
  }

/*
let goToUrl = dispatch => {
  URL.getAndThen((url) => {
    Js.log(url)
    switch url {
      | list{"elections", sUuid} =>
        //let nId = sId -> Int.fromString -> Option.getWithDefault(0)
        dispatch(Action.Navigate(ElectionBooth(sUuid)))
      | list{"profile"} =>
        dispatch(Action.Navigate(Route.User_Profile))
      | list{"users", "email_confirmation"} =>
        dispatch(Action.Navigate(Route.User_Register_Confirm(None, None)))
      | _ => ()
    }
  })
}

let tally = (privkey: Belenios.Trustees.Privkey.t, election: Election.t) => {
  dispatch => {
    let params = Option.getExn(election.params)
    let ballots =
      election.ballots
      -> Array.map((ballot) => ballot.ciphertext)
      -> Array.keep((ciphertext) => Option.getWithDefault(ciphertext, "") != "")
      -> Array.map((ciphertext) => Belenios.Ballot.of_str(Option.getExn(ciphertext)))
    let trustees = Belenios.Trustees.of_str(Option.getExn(election.trustees))
    let pubcreds : array<string> = %raw(`JSON.parse(election.creds)`)
    let (a, b) = Belenios.Election.decrypt(params, ballots, trustees, pubcreds, privkey)
    let res = Belenios.Election.result(params, ballots, trustees, pubcreds, a, b)
    dispatch(Action.Election_PublishResult(res))
  }
}
*/
