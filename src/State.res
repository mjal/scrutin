// The state of the application.

type t = {
  // The transactions.
  // See [[Transaction]]
  txs: array<Transaction.t>,

  // The controlled identities (as voter or election organizer)
  // See [[Identity]]
  ids: array<Identity.t>,

  // The controlled election private key (for tallying)
  // See [[Trustee]]
  trustees: array<Trustee.t>,

  // Contacts, to keep track on who is associated with which public key
  contacts: array<Contact.t>,

  // The current route (still waiting for a decent rescript router
  // that works on web and native)
  route: Route.t,

  // Cache of elections and ballot for fast lookup
  cached_elections: Map.String.t<Election.t>,
  cached_ballots:   Map.String.t<Ballot.t>
}

// The initial state of the application
let initial = {
  route: Home_Elections,
  txs: [],
  ids: [],
  trustees: [],
  contacts: [],
  cached_elections: Map.String.empty,
  cached_ballots: Map.String.empty,
}

// The reducer, the only place where state mutations can happen
let reducer = (state, action: StateMsg.t) => {
  switch action {

  | Reset =>
    (initial, [
      StateEffect.identities_fetch,
      StateEffect.transactions_fetch,
      StateEffect.trustees_fetch,
      StateEffect.contacts_fetch,
      StateEffect.goToUrl,
      StateEffect.importIdentityFromUrl,
    ])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [StateEffect.identities_store(ids)])

  | Transaction_Add(tx) =>
    let txs = Array.concat(state.txs, [tx])
    ({...state, txs}, [
      StateEffect.transactions_store(txs),
      StateEffect.transaction_broadcast(tx),
      StateEffect.cache_update(tx),
    ])

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [StateEffect.trustees_store(trustees)])

  | Contact_Add(contact) =>
    let contacts = Array.concat(state.contacts, [contact])
    ({...state, contacts}, [StateEffect.contacts_store(contacts)])

  | Cache_Election_Add(contentHash, election) =>
    let cached_elections =
      Map.String.set(state.cached_elections, contentHash, election)
    ({...state, cached_elections}, [])

  | Cache_Ballot_Add(contentHash, ballot) =>
    let cached_ballots =
      Map.String.set(state.cached_ballots, contentHash, ballot)
    ({...state, cached_ballots}, [])

  | Navigate(route) =>
    ({...state, route}, [])

  }
}
