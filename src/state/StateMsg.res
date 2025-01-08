type t =
  | Reset

  | Navigate(list<string>)
  | Navigate_Back
  | Navigate_About

  | Account_Add(Account.t)
  | Invitation_Add(Invitation.t)
  | Invitation_Remove(int)
  | Config_Store_Language(string)

  | Fetched

  | ElectionData_Set(string, ElectionData.t)

  | BallotAdd(string, Ballot.t)
  | UpdateNewElection(State.newElection)
  | CreateOpenElection(Setup.t)
  | CreateClosedElection
  | ElectionFetch(string)

  | UploadBallot(string, Election.t, Ballot.t)
