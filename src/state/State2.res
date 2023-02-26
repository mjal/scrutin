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

type t = {
  events: array<SEvent.Signed.t>,
  elections: Map.String.t<Election.t>,
  ballots: Map.String.t<Ballot.t>,
  user: option<User.t>,
  trustees: array<Trustee.t>
}

