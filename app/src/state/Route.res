type t =
  | Home
  | ElectionNew
  | ElectionShow(string)
  | ElectionBooth(string)
  | ElectionResult(string)
  | User_Profile
  | User_Register
  | User_Register_Confirm