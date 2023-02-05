// TODO: Rename to ModelAction instead of ActionModel
type t =
  | Init
  | Election_PublishResult(string)
  | Election_SetResult(string)
  | Election_SetName(string)
  | Election_SetBelenios(string, string, string)
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