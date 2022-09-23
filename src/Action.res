type t =
  | SetLoading(bool)
  | SetElectionName(string)
  | AddVoter(string)
  | RemoveVoter(string)
  | AddCandidate(string)
  | RemoveCandidate(string)
  | LoadElectionJson(Js.Json.t)
  | PostElection
