// TODO: Rename to ModelAction instead of ActionModel
type t =
  | Init
  | Election_PublishResult(string)
  | Election_SetResult(string)
  | SetElectionName(string)
  | SetElectionBelenios(string, string, string)
  | AddVoter(string)
  | RemoveVoter(int)
  | AddChoice(string)
  | RemoveChoice(int)
  | SetToken(string)
  | FetchElection(int)
  | LoadElection(Js.Json.t)
  | LoadElections(array<Js.Json.t>)
  | PostElection
  | BallotCreate(string, array<int>)
  | Navigate(Route.t)