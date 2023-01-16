@val external urlHash: string = "window.location.hash"

type t = {
  election: Election.t,
  user: User.t,
  ballot: SentBallot.t,
  loading: bool,
  route: Route.t
}

let initial = {
  election: Election.initial,
  user: { token: "" },
  ballot: SentBallot.initial,
  loading: false,
  route: Home
}

let effectLoadElection = id => {
  dispatch => {
    // Get the token from url
    let token = urlHash -> Js.String.sliceToEnd(~from=1)
    dispatch(Action.SetToken(token))

    Election.get(id)
    -> Promise.thenResolve(o => {
      dispatch(Action.LoadElection(o))
    }) -> ignore
  }
}

let effectCreateElection = state => {
  dispatch => {
    state.election
    -> Election.post
    -> Promise.then(Webapi.Fetch.Response.json)
    -> Promise.thenResolve(Election.from_json)
    -> Promise.thenResolve(election => {
      let id = election.id
      dispatch(Action.Navigate(Route.ElectionShow(id)))
    })
    -> ignore
  }
}

let effectBallotCreate = state => {
  dispatch => {
    Election.post_ballot(state.election, state.ballot)
    -> Promise.thenResolve(_ => {
      RescriptReactRouter.push(j`/elections/${state.election.id->Int.toString}/success`)
    })
    -> ignore
  }
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    | FetchElection(id) => ({
      ...state,
      loading: true,
      election: { ...Election.initial, id }
    }, [ effectLoadElection(id) ])
    | LoadElection(json) => ({
      ...state,
      loading: false,
      election: json->Election.from_json
    }, [])
    | PostElection => (state, [ effectCreateElection(state) ])
    | BallotCreate(choiceId) => {
      let newState = {...state, ballot:
        {
          electionId: state.election.id,
          choiceId,
          token: state.user.token
        }
      }
      (newState, [ effectBallotCreate(newState) ])
    }
    | SetToken(token) => {
      ({...state, user: {token: token}}, [])
    }
    | Navigate(route) =>
      ({...state, route}, [])
    | _ =>
    ({
      ...state,
      election: Election.reducer(state.election, action)
    }, [])
  }
}

// NOTE: Boilerplate for React's useContext hook
module StateContext = {
  let context = React.createContext(initial)

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

// NOTE: Boilerplate for React's useContext hook
module DispatchContext = {
  let context = React.createContext((_action: Action.t) => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

let useContextState = _ =>
  React.useContext(StateContext.context)

let useContextDispatch = _ =>
  React.useContext(DispatchContext.context)

// TODO: rename useContextReducer to useContext
let useContextReducer = _ =>
  (useContextState(), useContextDispatch())
