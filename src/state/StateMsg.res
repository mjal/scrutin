type t =
  | Reset
  | Navigate(list<string>)
  | Navigate_Back
  | Navigate_About
  | Account_Add(Account.t)
  | Event_Add(Event_.t)
  | Event_Add_With_Broadcast(Event_.t)
  | Trustee_Add(Trustee.t)
  | Invitation_Add(Invitation.t)
  | Invitation_Remove(int)
  | Config_Store_Language(string)
  | Fetching_Events_End

  | ElectionInit(string, Election.t)
  | ElectionUpdate(string, Election.t)

  | BallotAdd(string, Ballot.t)
