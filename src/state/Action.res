// TODO: Rename to ModelAction instead of ActionModel
type t =
  | Init
  | SetElectionName(string)
  | SetElectionBelenios(string, string, string)
  | SetToken(string)
  | AddVoter(string)
  | RemoveVoter(string)
  | AddChoice(string)
  | RemoveChoice(int)
  | FetchElection(int)
  | LoadElection(Js.Json.t)
  | LoadElections(array<Js.Json.t>)
  | PostElection
  | BallotCreate(string, array<int>)
  | Navigate(Route.t)