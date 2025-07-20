type t = {
  route: list<string>,
  electionDatas: Map.String.t<ElectionData.t>,
  electionsTryFetch: Map.String.t<bool>,
}

let initial = {
  route: list{""},
  electionDatas: Map.String.empty,
  electionsTryFetch: Map.String.empty,
}
