module Election = {
  type t = {
    params:   Belenios.Election.t,
    trustees: string,
    ownerPublicKey: string
  }
}

module Ballot = {
  type t = {
    electionEventHash: string,
    electionPublicKey: string,
    previousBallotEventHash: option<string>,
    ownerPublicKey: string,
    ciphertext: option<string>,
  }
}

module User = {
  type t = {
    publicKey: string,
    secretKey: option<string>
  }
}

module Action = {
  type t =
  | Transaction_Add(Transaction.Signed.t)
  | User_Login(User.t)
}

type cache_t = {
  elections: Map.String.t<Election.t>,
  ballots: Map.String.t<Ballot.t>
}

type t = {
  transactions: array<Transaction.Signed.t>,
  cache: cache_t,
  identities: array<User.t>,
  trustees: array<Trustee.t>
}

let initial = {
  transactions: [],
  identities: [],
  trustees: [],
  cache: {
    elections: Map.String.empty,
    ballots: Map.String.empty
  }
}

let rec reducer = (state, action) => {
  (state, [])
}
