module User = {
  type t = { token: string }
}

type state = {
  user: User.t,
  election: Election.t,
  loading: bool
}

let initialState = {
  user: { token: "" },
  election: Election.initial,
  loading: false
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    | SetLoading(loading) => { ...state, loading }
    | _ => {
      ...state,
      election: Election.reducer(state.election, action)
    }
  }
}
