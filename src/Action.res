type t =
  | Init
  | Navigate(Route.t)
  | Identity_Add(Identity.t)
  | Transaction_Add(Transaction.t)
  | Cache_Election_Add(string, Election.t)
  | Cache_Ballot_Add(string, Ballot.t)
