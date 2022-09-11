type user = { token: string }

type voter = { name: string }

type candidate = { name: string }

type election = {
  name: string,
  voters: array<voter>,
  candidates: array<candidate>
}

type state = {
  user: user,
  election: election
}

let initialState = {
  user: {
    token: ""
  },
  election: {
    name: "Élection sans nom",
    voters: [],
    candidates: []
  },
}

type action =
  | SetElectionName(string)
  | AddVoter(string)
  | RemoveVoter(string)
  | AddCandidate(string)
  | RemoveCandidate(string)

let reducer = (state, action) => {
  switch (action) {
    | SetElectionName(name) => {
      ...state,
      election: {
        ...state.election,
        name: name
      }
    }
    | AddVoter(name) => {
      ...state,
      election: {
        ...state.election,
        voters: Js.Array.concat([{ name: name } : voter], state.election.voters)
      }
    }
    | RemoveVoter(name) => {
      ...state,
      election: {
        ...state.election,
        voters: Js.Array2.filter(state.election.voters, voter => voter.name != name)
      }
    }
    | AddCandidate(name) => {
      ...state,
      election: {
        ...state.election,
        candidates: Js.Array.concat([{ name: name } : candidate], state.election.candidates)
      }
    }
    | RemoveCandidate(name) => {
      ...state,
      election: {
        ...state.election,
        candidates: Js.Array2.filter(state.election.candidates, e => e.name != name)
      }
    }
  }
}
