type t =
  | Home_Elections
  | Home_Identities
  | Home_Transactions
  | Election_New
  | Election_Show(string)
/*
type t =
  | Home
  | ElectionNew
  | ElectionShow(string)
  | ElectionBooth(string)
  | ElectionResult(string)
  | User_Profile
  | User_Register
  | User_Register_Confirm(option<string>, option<string>)
  | Admin_User_Show(User.t)
*/
