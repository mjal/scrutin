type state = {
  electionName: string,
  voters: array<string>,
  candidates: array<string>
}

type action =
  | SetElectionName(string)
  | AddVoter(string)
  | RemoveVoter(string)
  | AddCandidate(string)
  | RemoveCandidate(string)

let initialState = {
  electionName: "Élection sans nom",
  voters: [],
  candidates: []
}

let reducer = (state: state, action: action) : state => {
  switch (action) {
    | SetElectionName(electionName) =>
      {...state, electionName: electionName}
    | AddVoter(name) =>
      {...state, voters: Js.Array.concat(state.voters, [name])}
    | RemoveVoter(name) =>
      {...state, voters: Js.Array2.filter(state.voters, voterName => voterName != name)}
    | AddCandidate(name) =>
      {...state, candidates: Js.Array.concat(state.candidates, [name])}
    | RemoveCandidate(name) =>
      {...state, voters: Js.Array2.filter(state.candidates, candidateName => name != candidateName)}
  }
}
