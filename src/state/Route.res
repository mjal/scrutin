type t =
  | Home
  | ElectionNew
  | ElectionShow(string)
  | ElectionBooth(string)
  | ElectionResult(string)
  | Profile