/*
type t =
  | Ballot_Show(string)
  | Contact_Index
  | Election_Index
  | Election_New
  | Election_Show(string)
  | Event_Index
  | Identity_Index
  | Identity_Show(string)
  | Settings
  | Trustee_Index

let from_path = (path : list<string>) : t => {
  switch path {
  | list{"ballots",   id}    => Ballot_Show(id)
  | list{"elections", "new"} => Election_New
  | list{"elections", id}    => Election_Show(id)

  | list{"settings"}         => Settings

  | _ => Election_Index
  }
}

let to_path = (route : t) : list<string> => {
  switch route {
  | Trustee_Index     => list{"trustees"}
  | Event_Index       => list{"events"}
  | Contact_Index     => list{"contacts"}

  | Election_Index    => list{"elections"}
  | Election_New      => list{"elections", "new"}
  | Election_Show(electionId) => list{"elections", electionId}

  | Ballot_Show(ballotId) => list{"ballots", ballotId}

  | Identity_Index    => list{"identities"}
  | Identity_Show(publicKey) => list{"identities", publicKey}

  | Settings => list{"settings"}
  }
}
*/
