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

let reducer = (state, action) => {
  switch (action) {
    | SetElectionName(electionName) =>
      {...state, electionName: electionName}
    | AddVoter(name) =>
      {...state, voters: Js.Array.concat([name], state.voters)}
    | RemoveVoter(name) =>
      {...state, voters: Js.Array2.filter(state.voters, voterName => voterName != name)}
    | AddCandidate(name) =>
      {...state, candidates: Js.Array.concat([name], state.candidates)}
    | RemoveCandidate(name) =>
      {...state, voters: Js.Array2.filter(state.candidates, candidateName => name != candidateName)}
  }
}
