type t =
  | Reset
  | Navigate(Route.t)
  | Identity_Add(Identity.t)
  | Event_Add(Event_.t)
  | Event_Add_With_Broadcast(Event_.t)
  | Trustee_Add(Trustee.t)
  | Contact_Add(Contact.t)
  | Contact_Remove(int)
  | Cache_Election_Add(string, Election.t)
  | Cache_Ballot_Add(string, Ballot.t)
  | Cache_Tally_Add(string, ElectionTally.t)
  | Config_Store_Language(string)
