type t =
  | Init
  | Election_PublishResult(string)
  | Election_SetResult(option<string>)
  | Election_SetName(string)
  //| Election_SetBelenios(option<string>, option<string>, option<string>)
  | Election_AddVoter(string)
  | Election_RemoveVoter(int)
  | Election_AddChoice(string)
  | Election_RemoveChoice(int)
  | Election_Fetch(int)
  | Election_Load(Js.Json.t)
  | Election_LoadAll(array<Js.Json.t>)
  | Election_Post
  | Ballot_Create(string, array<int>)
  | Navigate(Route.t)
  | User_Login(User.t)