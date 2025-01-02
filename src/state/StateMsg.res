type t =
  | Reset
  | Navigate(list<string>)
  | Navigate_Back
  | Navigate_About
  | Account_Add(Account.t)
//| Event_Add(Event_.t)
//| Event_Add_With_Broadcast(Event_.t)
//| Trustee_Add(Trustee.t)
  | Invitation_Add(Invitation.t)
  | Invitation_Remove(int)
  | Config_Store_Language(string)

//| FetchLatest
  | Fetched

//| ElectionSetup(string, Setup.t)
  | ElectionAdd(string, Setup.t, array<Ballot.t>)
//| ElectionInit(string, Election.t)

  | BallotAdd(string, Ballot.t)
  | UpdateNewElection(State.newElection)
  | CreateOpenElection(Setup.t)
  | CreateClosedElection
  | ElectionFetch(string)

  | UploadBallot(string, Election.t, Ballot.t)
