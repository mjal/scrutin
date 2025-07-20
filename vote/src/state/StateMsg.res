type t =
  | Reset

  | Navigate(list<string>)

  | Config_Store_Language(string)

  | Election_Fetch(string)
  | Election_Set(string, ElectionData.t)
