type t =
  | Home
  | ElectionNew
  | ElectionShow(string)
  | ElectionBooth(string)
  | ElectionResult(string)
  | User_Profile
  | User_Signin
  | User_Signup