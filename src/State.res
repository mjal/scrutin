type cache_t = {
  elections: Map.String.t<Election.t>,
  ballots: Map.String.t<Ballot.t>
}

type t = {
  route: Route.t,
  ids: array<Identity.t>,
  txs: array<Transaction.t>,
  trustees: array<Trustee.t>,
  cache: cache_t,
}

let initial = {
  route: Home_Elections,
  txs: [],
  ids: [],
  trustees: [],
  cache: {
    elections: Map.String.empty,
    ballots: Map.String.empty
  }
}

let reducer = (state, action: Action.t) => {
  switch action {

  | Init =>
    (initial, [
      Effect.identities_fetch,
      Effect.transactions_fetch,
    ])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [Effect.identities_store(ids)])

  | Transaction_Add(tx) =>
    let txs = Array.concat(state.txs, [tx])
    ({...state, txs}, [
      Effect.transactions_store(txs),
      Effect.cache_update(tx)
    ])

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [Effect.trustees_store(trustees)])

  | Cache_Election_Add(eventHash, election) =>
    let elections = Map.String.set(state.cache.elections, eventHash, election)
    let cache = {...state.cache, elections}
    ({...state, cache}, [])

  | Cache_Ballot_Add(eventHash, ballot) =>
    let ballots = Map.String.set(state.cache.ballots, eventHash, ballot)
    let cache = {...state.cache, ballots}
    ({...state, cache}, [])

  | Navigate(route) =>
    ({...state, route}, [])

  }
}
