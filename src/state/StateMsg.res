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

  | FetchLatest
  | Fetched

  | ElectionInit(string, Sirona.Election.t)

  | BallotAdd(string, Ballot.t)
  | UpdateNewElection(State.newElection)
  | CreateOpenElection
  | CreateClosedElection
  | ElectionFetch(string)
