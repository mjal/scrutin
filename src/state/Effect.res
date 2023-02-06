let loadElections = (dispatch) => {
  Election.getAll()
  -> Promise.thenResolve(res => {
    switch Js.Json.decodeArray(res) {
      | Some(json_array) => dispatch(Action.Election_LoadAll(json_array))
      | None => dispatch(Action.Election_LoadAll([]))
    }
  }) -> ignore
}

let loadElection = id => {
  dispatch => {
    Election.get(id)
    -> Promise.thenResolve(o => {
      dispatch(Action.Election_Load(o))
    }) -> ignore
  }
}

let createElection = (election : Election.t) => {
  dispatch => {
    let (privkey, trustees) = Belenios.Trustees.create()

    ReactNativeAsyncStorage.setItem(Belenios.Trustees.pubkey(trustees), Belenios.Trustees.Privkey.to_str(privkey)) -> ignore

    let params = Belenios.Election.create(
      ~name=election.name,
      ~description="description",
      ~choices=Array.map(election.choices, (o) => o.name),
      ~trustees=trustees
    )

    let (pubcreds, privcreds) = Belenios.Credentials.create(params.uuid, Array.length(election.voters))
    let creds = Array.zip(pubcreds, privcreds)

    //dispatch(Action.SetElectionBeleniosParams(belenios_params))

    let voters = Array.zip(election.voters, creds)
    -> Array.map(((voterWithoutCred, (pubCred, privCred))) => {
      let voter : Voter.t = {...voterWithoutCred, pubCred, privCred}
      voter
    })

    let election = {
      ...election,
      uuid: Some(params.uuid),
      params: Some(params),
      trustees: Some(Belenios.Trustees.to_str(trustees)),
      creds: Js.Json.stringifyAny(pubcreds),
      voters
    }

    election
    -> Election.post
    -> Promise.then(Webapi.Fetch.Response.json)
    -> Promise.thenResolve((res) => {
      dispatch(Action.Election_Load(res))
      let id = (Election.from_json(res)).id
      dispatch(Action.Navigate(Route.ElectionBooth(id)))
    })
    -> ignore
  }
}


let ballotCreate = (election, token, selection) => {
  dispatch => {
    let ballot = Election.createBallot(election, token, selection)

    Election.post_ballot(election, ballot)
    -> Promise.thenResolve(res => {
      Js.log(res)
      ()
      //RescriptReactRouter.push(j`/elections/${state.election.id->Int.toString}/success`)
    })
    -> ignore
  }
}

let publishElectionResult = (election, result) => {
  dispatch => {
    Election.post_result(election, result)
    -> Promise.thenResolve(_ => {
      dispatch(Action.Election_SetResult(Some(result)))
      ()
    })
    -> ignore
  }
}

let goToUrl = dispatch => {
  ReactNative.Linking.getInitialURL()
  -> Promise.thenResolve(res => {
    let sUrl = res -> Js.Null.toOption -> Option.getWithDefault("")
    let url = URL.make(sUrl)
    let oResult = Js.Re.exec_(%re("/^\/elections\/(.*)/g"), URL.pathname(url))
    let capture = switch oResult {
    | Some(result) =>
      switch Js.Re.captures(result)[1] {
        | Some(str) => Js.toOption(str)
        | None => None
      }
    | None => None
    }
    switch capture {
      | Some(sId) => dispatch(Action.Navigate(ElectionBooth(sId -> Int.fromString -> Option.getWithDefault(0))))
      | None => ()
    }
  }) -> ignore
}