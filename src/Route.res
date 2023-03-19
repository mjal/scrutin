type t =
  | Home_Elections
  | Home_Trustees
  | Home_Identities
  | Home_Transactions
  | Election_New
  | Election_Show(string)
  | Identity_Show(string)
  | Ballot_Show(string)
  | Settings
