// HACK: Required for netlify compile
%%raw(`/* eslint-disable default-case */`)
%%raw(`/* eslint-disable no-throw-literal */`)

type t = {
  id:       int,
  name:     string,
  voters:   array<Voter.t>,
  choices:  array<Choice.t>,
  ballots:  array<Ballot.t>,
  uuid:     option<string>,
  params:   option<Belenios.Election.t>,
  trustees: option<string>,
  creds:    option<string>,
  result:   option<string>,
  administrator_id: int,
}

let initial = {
  id: 0,
  name: "",
  voters: [],
  choices: [],
  ballots: [],
  params: None,
  trustees: None,
  creds: None,
  uuid: None,
  result: None,
  administrator_id: 0
}

let to_json = (r) => {
  open! Json.Encode
  Unsafe.object({
    "id": int(r.id),
    "name": string(r.name),
    "voters": array(Voter.to_json, r.voters),
    "choices": array(Choice.to_json, r.choices),
    "ballots": array(Ballot.to_json, r.ballots),
    "uuid": option(string, r.uuid),
    "params": option(string, r.params -> Option.map(Belenios.Election.stringify)),
    "trustees": option(string, r.trustees),
    "creds": option(string, r.creds),
    "result": option(string, r.result)
  })
}

// TODO: Check if there is an exception in the Json* lib
exception DecodeError({error: string})
let from_json = (json) => {
  open Json.Decode
  let decode = object(field => {
    {
      id: field.required(. "id", int),
      name: field.required(. "name", string),
      voters: field.required(. "voters", array(Voter.from_json)), // TODO: Make it optional
      choices: field.required(. "choices", array(Choice.from_json)),
      ballots: field.required(. "ballots", array(Ballot.from_json)),
      uuid: field.required(. "uuid", option(string)),
      params: field.required(. "params", option(string)) -> Option.map(Belenios.Election.parse),
      trustees: field.required(. "trustees", option(string)),
      creds: field.required(. "creds", option(string)),
      result: field.required(. "result", option(string)),
      administrator_id: field.required(. "administrator_id", option(int)) -> Option.getWithDefault(0)
    }
  })
  switch (json->Json.decode(decode)) {
    | Ok(result) => result
    | Error(error) => {
      raise(DecodeError({error}))
    }
  }
}

let get = (id) => {
  Webapi.Fetch.fetch(j`${Config.api_url}/elections/$id`)
  -> Promise.then(Webapi.Fetch.Response.json)
}

let getAll = () => {
  Webapi.Fetch.fetch(j`${Config.api_url}/elections`)
  -> Promise.then(Webapi.Fetch.Response.json)
}

let post = (election, user: User.t) => {
  let dict = Js.Dict.empty()
  Js.Dict.set(dict, "election", election -> to_json)
  Js.Dict.set(dict, "user", user -> User.to_json)
  let object = Js.Json.object_(dict)
  X.post(`${Config.api_url}/elections/`, object)
}

let post_ballot = (election, ballot: Ballot.t) => {
  let election_id = election.id -> Int.toString
  X.post(`${Config.api_url}/elections/${election_id}/ballots`, ballot -> Ballot.to_json)
}

let post_result = (election, result: string) => {
  let election_id = election.id -> Int.toString
  let dict = Js.Dict.empty()
  Js.Dict.set(dict, "result", Js.Json.string(result))
  X.post(`${Config.api_url}/elections/${election_id}/result`, Js.Json.object_(dict))
}

let createBallot = (election : t, private_credential : string, selection : array<int>) : Ballot.t => {
  let trustees = Belenios.Trustees.of_str(Option.getExn(election.trustees))

  let ciphertext =
    Belenios.Election.vote(Option.getExn(election.params), ~cred=private_credential, ~selections=[selection], ~trustees)
    -> Belenios.Ballot.to_str

  {
    electionId: election.id,
    ciphertext: Some(ciphertext),
    public_credential: "", // TODO: Get from Belenios lib
    private_credential
  }
}

let reducer = (election, action) => {
  switch(action: Action.t) {
    | Election_SetName(name) => {
      ...election,
      name: name
    }
    //| Election_SetBelenios(params, trustees, creds) => {
    //  ...election,
    //  params, trustees, creds
    //}
    | Election_AddVoter(email) => {
      ...election,
      voters: Array.concat(election.voters, [{ id: 0, email: email, pubCred: "", privCred: "" }: Voter.t])
    }
    | Election_RemoveVoter(index) => {
      ...election,
      voters: Array.keepWithIndex(election.voters, (_, i) => i != index)
    }
    // TODO: Generate unique negative index. Use it for RemoveChoice and index=
    | Election_AddChoice(name) => {
      ...election,
      choices: Array.concat(election.choices, [{ id: 0, name: name }: Choice.t])
    }
    | Election_RemoveChoice(index) => {
      ...election,
      choices: Array.keepWithIndex(election.choices, (_, i) => i != index)
    }
    | Election_SetResult(result) => {...election, result}
    | _ => election
  }
}
