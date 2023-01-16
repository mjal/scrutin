// TODO: Rename to ModelAction instead of ActionModel
type t =
  | Init
  | SetElectionName(string)
  | SetToken(string)
  | AddVoter(string)
  | RemoveVoter(string)
  | AddChoice(string)
  | RemoveChoice(string)
  | FetchElection(int)
  | LoadElection(Js.Json.t)
  | PostElection
  | BallotCreate(int)
  | Navigate(Route.t)