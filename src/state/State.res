type t = {
  // Is the app init ?
  init: bool,

  // The current election (when creating a new election, or when showing an election)
  election: Election.t,

  // Elections fetched from the servers
  elections: array<Election.t>,
  elections_loading: bool,

 // The current user (now only to store the voting token)
  user: User.t,

  // The ballot to send when we want to vote
  ballot: SentBallot.t, 

  // Is the app waiting for remote data ?
  loading: bool,

  // A basic router
  route: Route.t,
}

let initial = {
  init: false,
  election: Election.initial,
  user: { token: "" },
  ballot: SentBallot.initial,
  loading: false,
  route: Home,
  elections: [],
  elections_loading: false
}

let effectLoadElections = () => {
  dispatch => {
    Election.getAll()
    -> Promise.thenResolve(res => {
      switch Js.Json.decodeArray(res) {
        | Some(json_array) => dispatch(Action.LoadElections(json_array))
        | None => dispatch(Action.LoadElections([]))
      }
    }) -> ignore
  }
}

@val external urlHash: string = "window.location.hash"

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

    let (privkey, trustees) = Belenios.Trustees.create()

    let belenios_params = Belenios.Election.create(
      ~name=state.election.name,
      ~description="description",
      ~choices=Array.map(state.election.choices, (o) => o.name),
      ~trustees=trustees
    ) |> Belenios.Election.to_str

    //dispatch(Action.SetElectionBeleniosParams(belenios_params))

    let election = {...state.election, belenios_params}

    election
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
      ()
      //RescriptReactRouter.push(j`/elections/${state.election.id->Int.toString}/success`)
    })
    -> ignore
  }
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    | Init => ({...state, elections_loading: true, init: true}, [effectLoadElections()])
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
    | LoadElections(jsons) => ({
      ...state,
      elections_loading: false,
      elections: Js.Array2.map(jsons, Election.from_json)
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
      let effects = switch route {
        | ElectionShow(id) => [effectLoadElection(id)]
        | _ => []
      }
      ({...state, route}, effects)
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
let useContexts = _ =>
  (useContextState(), useContextDispatch())
