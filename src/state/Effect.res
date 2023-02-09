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

let createElection = (election : Election.t, user: User.t) => {
  dispatch => {
    let (privkey, trustees) = Belenios.Trustees.create()
    Store.Trustee.add({pubkey: Belenios.Trustees.pubkey(trustees), privkey})

    let params = Belenios.Election.create(
      ~name=election.name,
      ~description="description",
      ~choices=Array.map(election.choices, (o) => o.name),
      ~trustees=trustees
    )

    let (pubcreds, privcreds) = Belenios.Credentials.create(params.uuid, Array.length(election.voters))
    let creds = Array.zip(pubcreds, privcreds)

    Array.forEach(creds, ((public, private_)) => {
      Js.log("Adding token: ")
      let token : Token.t = {public, private_}
      Js.log(token)
      Store.Token.add(token)
    })

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
      creds: Js.Json.stringifyAny(pubcreds), // TODO: Try Belenios.Credentials.stringify
      voters
    }

    election
    -> Election.post(user)
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
  URL.getAndThen((url) => {
    switch url {
      | list{"elections", sId} =>
        let nId = sId -> Int.fromString -> Option.getWithDefault(0)
        dispatch(Action.Navigate(ElectionBooth(nId)))
      | list{"profile"} =>
        dispatch(Action.Navigate(Route.Profile))
      | _ => ()
    }
  })
}

module Store = {
  module User = {
    let get = dispatch => {
      Store.User.get()
      -> Promise.thenResolve((oUser) => {
        switch oUser {
        | None => ()
        | Some(user) => dispatch(Action.User_Login(user))
        }
      })
      -> ignore
    }

    let set = (user) => {
      _dispatch => {
        Store.User.set(user)
        -> ignore
      }
    }

    let clean = _dispatch => Store.User.clean()
  }

  module Trustees = {
    let get = dispatch => {
      Store.Trustee.get()
      -> Promise.thenResolve(trustees => {
        dispatch(Action.Trustees_Set(trustees))
      }) -> ignore
    }

    let add = ({pubkey, privkey} : Trustee.t) => {
      _dispatch => {
        //let pubkey = Belenios.Trustees.pubkey(trustees)
        //let privkey = Belenios.Trustees.Privkey.to_str(privkey)
        Store.Trustee.add({pubkey, privkey})
      }
    }

    let clean = _dispatch => Store.Trustee.clean()
  }

  module Tokens = {
    let get = dispatch => {
      Store.Token.get()
      -> Promise.thenResolve(trustees => {
        dispatch(Action.Tokens_Set(trustees))
      }) -> ignore
    }

    let add = (token : Token.t) => {
      _dispatch => {
        Store.Token.add(token)
      }
    }

    let clean = _dispatch => Store.Token.clean()
  }
}