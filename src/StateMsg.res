type t =
  | Reset
  | Navigate(Route.t)
  | Identity_Add(Identity.t)
  | Transaction_Add(Transaction.t)
  | Transaction_Add_With_Broadcast(Transaction.t)
  | Trustee_Add(Trustee.t)
  | Contact_Add(Contact.t)
  | Cache_Election_Add(string, Election.t)
  | Cache_Ballot_Add(string, Ballot.t)
