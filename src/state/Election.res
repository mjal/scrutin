// HACK: Required for netlify compile
%%raw(`/* eslint-disable default-case */`)
%%raw(`/* eslint-disable no-throw-literal */`)

type t = {
  id: int,
  name: string,
  voters: array<Voter.t>,
  choices: array<Choice.t>,
  ballots: array<Ballot.t>,
  params: option<string>,
  trustees: option<string>,
  creds: option<string>,
  uuid: string,
  result: option<string>
}

let initial = {
  id: 0,
  name: "",
  voters: [],
  choices: [],
  ballots: [],
  params: "",
  trustees: "",
  creds: "",
  uuid: "",
  result: ""
}

let to_json = (r) => {
  open! Json.Encode
  Unsafe.object({
    "id": int(r.id),
    "name": string(r.name),
    "voters": array(Voter.to_json, r.voters),
    "choices": array(Choice.to_json, r.choices),
    "ballots": array(Ballot.to_json, r.ballots),
    "params": string(r.params),
    "trustees": string(r.trustees),
    "creds": string(r.creds),
    "uuid": string(r.uuid),
    "result": string(r.result)
  })
}

// TODO: Check if there is an exception in the Json* lib
exception DecodeError({error: string})
let from_json = (json) => {
  open Json.Decode
  let decode = object(field => {
    id: field.required(. "id", int),
    name: field.required(. "name", string),
    voters: field.required(. "voters", array(Voter.from_json)), // TODO: Make it optional
    choices: field.required(. "choices", array(Choice.from_json)),
    ballots: field.required(. "ballots", array(Ballot.from_json)),
    params: field.required(. "params", string),
    trustees: field.required(. "trustees", string),
    creds: field.required(. "creds", string),
    uuid: field.required(. "uuid", string),
    result: field.required(. "result", string)
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

let post = (election) => {
  X.post(`${Config.api_url}/elections/`, election -> to_json)
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
  let params = Belenios.Election.of_str(election.params)
  let trustees = Belenios.Trustees.of_str(election.trustees)

  let ciphertext =
    Belenios.Election.vote(params, private_credential, [selection], trustees)
    -> Belenios.Ballot.to_str

  Js.log("ciphertext")
  Js.log(ciphertext)

  {
    electionId: election.id,
    ciphertext,
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
    | Election_SetBelenios(params, trustees, creds) => {
      ...election,
      params, trustees, creds
    }
    // TODO: Generate unique negative index. Use it for RemoveVoter and index=
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
