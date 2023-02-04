type t =
  | Home
  | ElectionNew
  | ElectionShow(int)
  | ElectionBooth(int)
  | ElectionResult(int)