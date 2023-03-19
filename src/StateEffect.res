// ## Cache management

let cache_update = (tx : Transaction.t) =>
  (dispatch) => {
    switch tx.type_ {
    | #election => dispatch(StateMsg.Cache_Election_Add(tx.contentHash,
      Transaction.SignedElection.unwrap(tx)))
    | #ballot => dispatch(StateMsg.Cache_Ballot_Add(tx.contentHash,
      Transaction.SignedBallot.unwrap(tx)))
    }
  }

// ## LocalStorage - Store

let identities_store = (ids) => (_dispatch) => Identity.store_all(ids)
let transactions_store = (txs) => (_dispatch) => Transaction.store_all(txs)
let trustees_store = (trustees) => (_dispatch) => Trustee.store_all(trustees)
let contacts_store = (contacts) => (_dispatch) => Contact.store_all(contacts)

// ## LocalStorage - Fetch

let identities_fetch = (dispatch) => {
  Identity.fetch_all()
  -> Promise.thenResolve((ids) => {
    Array.map(ids, (id) => dispatch(StateMsg.Identity_Add(id)))
    // FIX: Identity_Add call identites_store as an effect...
  }) -> ignore
}

let transactions_fetch = (dispatch) => {
  Transaction.fetch_all()
  -> Promise.thenResolve((txs) => {
    Array.map(txs, (tx) => dispatch(StateMsg.Transaction_Add(tx)))
  }) -> ignore
}

let trustees_fetch = (dispatch) => {
  Trustee.fetch_all()
  -> Promise.thenResolve((txs) => {
    Array.map(txs, (tx) => dispatch(StateMsg.Trustee_Add(tx)))
  }) -> ignore
}

// ## LocalStorage - Clear

let identities_clear = (_dispatch) => Identity.clear()
let transactions_clear = (_dispatch) => Transaction.clear()
let trustees_clear = (_dispatch) => Trustee.clear()

// ## Redirect based on url

let goToUrl = (dispatch) => {
  URL.getAndThen((url) => {
    switch url {
      | list{"ballots", txHash} =>
        let _ = Js.Global.setTimeout(() => {
          dispatch(StateMsg.Navigate(Ballot_Show(txHash)))
        }, 500)
      | _ => ()
    }
  })
}

// ## Save secret keys passed by url #hash

let importIdentityFromUrl = (dispatch) => {
  if String.length(URL.getCurrentHash()) > 12 {
    let currentHash = URL.getCurrentHash()
    let hexSecretKey = String.sub(currentHash, 1,
      String.length(currentHash) - 1)
    Js.log(hexSecretKey)
    dispatch(StateMsg.Identity_Add(Identity.make2(~hexSecretKey)))
  }
}
