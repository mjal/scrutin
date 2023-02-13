type t = {
  election: Election.t,
  elections: array<Election.t>,
  elections_loading: bool,
  user: option<User.t>,
  loading: bool, // Obsolete
  voting_in_progress: bool,
  route: Route.t,
  trustees: array<Trustee.t>,
  tokens:   array<Token.t>,
}

let initial = {
  election: Election.initial,
  user: None,
  loading: false,
  voting_in_progress: false,
  route: Home,
  elections: [],
  elections_loading: false,
  trustees: [],
  tokens: []
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    
    | Init => ({...state, elections_loading: true}, [
      Effect.goToUrl,
      Effect.loadElections,
      Effect.Store.User.get,
      Effect.Store.Trustees.get,
      Effect.Store.Tokens.get,
      (_ => Belenios.Random.generate())
    ])

    | Election_Fetch(id) => ({
      ...state,
      loading: true,
      election: { ...Election.initial, id }
    }, [ Effect.loadElection(id) ])

    | Election_Load(json) => ({
      ...state,
      loading: false,
      election: json->Election.from_json
    }, [])

    | Election_LoadAll(jsons) => ({
      ...state,
      elections_loading: false,
      elections: Array.map(jsons, Election.from_json) -> Array.reverse
    }, [])

    | Election_Post => (state, [ Effect.createElection(state.election, Option.getExn(state.user)) ])

    | Election_PublishResult(result) => {
      //let election = {...state.election, result}
      (state, [Effect.publishElectionResult(state.election, result)])
    }

    | Ballot_Create_Start(token, selection) => {
      ({...state, voting_in_progress: true},
       [ Effect.ballotCreate(state.election, token, selection) ])
    }

    | Ballot_Create_End => {
      ({...state, voting_in_progress: false}, [])
    }

    | Navigate(route) =>
      let () = switch route {
        | ElectionBooth(id) | ElectionShow(id) | ElectionResult(id) =>
          X.setUrlPathname(`/elections/${id->Int.toString}`)
        | Home => X.setUrlPathname("/")
        | Profile => X.setUrlPathname("/profile")
        | _ => ()
      }
      let effects = switch route {
        | ElectionBooth(id) | ElectionShow(id) | ElectionResult(id) =>
          [Effect.loadElection(id)]
        | _ => []
      }
      ({...state, route}, effects)

    | User_Login(user) =>
      ({...state, user: Some(user)}, [Effect.Store.User.set(user)])

    | User_Logout =>
      ({...state, user: None}, [Effect.Store.User.clean])

    | Trustees_Set(trustees) =>
      ({...state, trustees}, [])

    | Tokens_Set(tokens) =>
      ({...state, tokens}, [])

    | _ =>
      ({
        ...state,
        election: Election.reducer(state.election, action)
      }, [])
  }
}