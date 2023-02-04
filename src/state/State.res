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

let effectLoadElections = (dispatch) => {
  Election.getAll()
  -> Promise.thenResolve(res => {
    switch Js.Json.decodeArray(res) {
      | Some(json_array) => dispatch(Action.LoadElections(json_array))
      | None => dispatch(Action.LoadElections([]))
    }
  }) -> ignore
}

let effectLoadElection = id => {
  dispatch => {
    Election.get(id)
    -> Promise.thenResolve(o => {
      dispatch(Action.LoadElection(o))
    }) -> ignore
  }
}

let effectCreateElection = state => {
  dispatch => {
    let (privkey, trustees) = Belenios.Trustees.create()

    ReactNativeAsyncStorage.setItem(Belenios.Trustees.pubkey(trustees), Belenios.Trustees.Privkey.to_str(privkey)) -> ignore

    let params = Belenios.Election.create(
      ~name=state.election.name,
      ~description="description",
      ~choices=Array.map(state.election.choices, (o) => o.name),
      ~trustees=trustees
    )

    let uuid = Belenios.Election.uuid(params)

    let (pubcreds, privcreds) = Belenios.Credentials.create(uuid, Array.length(state.election.voters))
    let creds = Array.zip(pubcreds, privcreds)

    //dispatch(Action.SetElectionBeleniosParams(belenios_params))

    let voters = Array.zip(state.election.voters, creds)
    -> Array.map(((voterWithoutCred, (pubCred, privCred))) => {
      let voter : Voter.t = {...voterWithoutCred, pubCred, privCred}
      voter
    })
 
    let election = {
      ...state.election,
      uuid,
      params: Belenios.Election.to_str(params),
      trustees: Belenios.Trustees.to_str(trustees),
      creds: Option.getExn(Js.Json.stringifyAny(pubcreds)),
      voters
    }

    election
    -> Election.post
    -> Promise.then(Webapi.Fetch.Response.json)
    -> Promise.thenResolve(Election.from_json)
    -> Promise.thenResolve(election => {
      let id = election.id
      dispatch(Action.Navigate(Route.ElectionBooth(id)))
    })
    -> ignore
  }
}

let effectBallotCreate = (state, token, selection) => {
  dispatch => {
    let ballot = Election.createBallot(state.election, token, selection)

    Election.post_ballot(state.election, ballot)
    -> Promise.thenResolve(res => {
      Js.log(res)
      ()
      //RescriptReactRouter.push(j`/elections/${state.election.id->Int.toString}/success`)
    })
    -> ignore
  }
}

let effectPublishElectionResult = (state, result) => {
  dispatch => {
    Election.post_result(state.election, result)
    -> Promise.thenResolve(_ => {
      dispatch(Action.Election_SetResult(result))
      ()
    })
    -> ignore
  }
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    | Init => ({...state, elections_loading: true, init: true}, [effectLoadElections])
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
      elections: Array.map(jsons, Election.from_json) -> Array.reverse
    }, [])
    | PostElection => (state, [ effectCreateElection(state) ])
    | Election_PublishResult(result) => {
      //let election = {...state.election, result}
      (state, [effectPublishElectionResult(state, result)])
    }
    | BallotCreate(token, selection) => {
      (state, [ effectBallotCreate(state, token, selection) ])
    }
    | SetToken(token) => {
      ({...state, user: {token: token}}, [])
    }
    | Navigate(route) =>
      let effects = switch route {
        | ElectionBooth(id) => [effectLoadElection(id)]
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

module StateContext = {
  let context = React.createContext(initial)

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }

  let use = () => React.useContext(context)
}

module DispatchContext = {
  let context = React.createContext((_action: Action.t) => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }

  let use = () => React.useContext(context)
}

let useContexts = () => (StateContext.use(), DispatchContext.use())
