open Belt; open Helper

module Voter = {
  type t = { name: string }
}

module Candidate = {
  type t = { name: string }
}

type t = {
  id: int,
  name: string,
  voters: array<Voter.t>,
  candidates: array<Candidate.t>
}

let initial = {
  id: 0,
  name: "Élection sans nom",
  voters: [],
  candidates: []
}

let to_json = (election) => {
  let dict = Js.Dict.empty()
  Js.Dict.set(dict, "name", Js.Json.string(election.name))
  let voters =
    election.voters
    -> Js.Array2.map(voter => {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "name", Js.Json.string(voter.name))
      Js.Json.object_(dict)
    })
    -> Js.Json.array
  Js.Dict.set(dict, "voters", voters)
  let candidates =
    election.candidates
    -> Js.Array2.map(candidate => {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "name", Js.Json.string(candidate.name))
      Js.Json.object_(dict)
    })
    -> Js.Json.array
  Js.Dict.set(dict, "candidates", candidates)
  Js.Json.object_(dict)
}

let from_json = (json) => {
  switch Js.Json.classify(json) {
    | Js.Json.JSONObject(o) =>
      let id = Js.Dict.get(o, "id")
      -> bind(Js.Json.decodeNumber)
      -> Option.getExn
      -> Int.fromFloat

      let name = Js.Dict.get(o, "name")
      -> bind(Js.Json.decodeString)
      -> Option.getExn

      let candidates = Js.Dict.get(o, "candidates")
      -> bind(Js.Json.decodeArray)
      -> Option.getExn
      -> Array.map(o => {
        switch Js.Json.classify(o) {
          | Js.Json.JSONObject(o) =>
            let name = Js.Dict.get(o, "name")
            -> bind(Js.Json.decodeString)
            -> Option.getExn
            ({ name: name } : Candidate.t)
          | _ => Js.Exn.raiseError("Parsing Error")
        }
      })

      { id: id, name, candidates, voters: [] }
    | _ => initial
  }
}

let reducer = (election, action) => {
  switch(action: Action.t) {
    | SetElectionName(name) => {
      ...election,
      name: name
    }
    | AddVoter(name) => {
      ...election,
      voters: Js.Array2.concat([{ name:name }: Voter.t], election.voters)
    }
    | RemoveVoter(name) => {
      ...election,
      voters: Js.Array2.filter(election.voters, voter => voter.name != name)
    }
    | AddCandidate(name) => {
      ...election,
      candidates: Js.Array2.concat([{ name:name }: Candidate.t], election.candidates)
    }
    | RemoveCandidate(name) => {
      ...election,
      candidates: Js.Array2.filter(election.candidates, e => e.name != name)
    }
    | LoadElectionJson(json) => from_json(json)
    | _ => election
  }
}

let get = (id) => {
  Webapi.Fetch.fetch(j`http://localhost:8000/elections/$id`)
  -> Promise.then(Webapi.Fetch.Response.json)
}

let post = (election) => {
  let headers = {
    "Content-Type": "application/json"
  }
  -> Webapi.Fetch.HeadersInit.make

  let body = election
  -> to_json
  -> Js.Json.stringify
  -> Webapi.Fetch.BodyInit.make

  Webapi.Fetch.fetchWithInit(
    `${Config.api_url}/elections/`,
    Webapi.Fetch.RequestInit.make(~method_=Post, ~body, ~headers, ()),
  )
}
