type cache_t = {
  elections: Map.String.t<Election.t>,
  ballots: Map.String.t<Ballot.t>
}

type t = {
  route: Route.t,
  ids: array<Identity.t>,
  txs: array<Transaction.t>,
  trustees: array<Trustee.t>,
  cache: cache_t,
}

let initial = {
  route: Home,
  txs: [],
  ids: [],
  trustees: [],
  cache: {
    elections: Map.String.empty,
    ballots: Map.String.empty
  }
}

let rec reducer = (state, action: Action.t) => {
  switch action {

  | Init =>
    (state, [
      Effect.identities_fetch,
      Effect.transactions_fetch,
    ])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [Effect.identities_store(ids)])

  | Transaction_Add(tx) =>
    let txs = Array.concat(state.txs, [tx])
    ({...state, txs}, [Effect.transactions_store(txs)])

  | Navigate(route) => ({...state, route}, [])

  }
}

/*
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

let rec reducer = (state, action: Action.t) => {
  switch (action) {

    | Init => ({...state, elections_loading: true}, [
      Effect.goToUrl,
      //Effect.loadElections,
      Effect.Store.User.get,
      Effect.Store.Trustees.get,
      Effect.Store.Tokens.get,
    ])

    | Election_Fetch(uuid) => ({
      ...state,
      loading: true,
      election: { ...Election.initial, uuid: Some(uuid) }
    }, [ Effect.loadElection(uuid) ])

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

    | Election_Tally(privkey) => {
      (state, [Effect.tally(privkey, state.election)])
    }

    | Ballot_Create_Start(token, selection) => {
      ({...state, voting_in_progress: true},
       [ Effect.ballotCreate(state.election, token, selection) ])
    }

    | Ballot_Create_End => {
      reducer({...state, voting_in_progress: false}, Action.Navigate(ElectionShow(state.election.uuid->Option.getExn)))
    }

    | Navigate(route) =>
      Js.log("Navigate")
      Js.log(route)
      let () = switch route {
        | ElectionBooth(uuid) | ElectionShow(uuid) | ElectionResult(uuid) =>
          URL.setUrlPathname(`/elections/${uuid}${URL.currentHash()}`)
        | Home => URL.setUrlPathname("/")
        | User_Profile => URL.setUrlPathname("/profile")
        | _ => ()
      }
      let effects = switch route {
        | ElectionBooth(uuid) | ElectionShow(uuid) | ElectionResult(uuid) =>
          [Effect.loadElection(uuid)]
        | _ => []
      }
      let election = if route == ElectionNew { Election.initial } else { state.election }
      ({...state, election, route}, effects)

    | User_Login(user) =>
      ({...state, user: Some(user), route: Route.Home}, [Effect.Store.User.set(user)])

    | User_Logout =>
      ({...state, user: None, route: Home}, [Effect.Store.User.clean])

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
*/
