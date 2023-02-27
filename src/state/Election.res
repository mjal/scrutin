// HACK: Required for netlify compile
%%raw(`/* eslint-disable default-case */`)
%%raw(`/* eslint-disable no-throw-literal */`)
/*
type t = {
  uuid:     option<string>,
  name:     string,
  voters:   array<Voter.t>,
  choices:  array<Choice.t>,
  ballots:  array<Ballot.t>,
  params:   option<Belenios.Election.t>,
  trustees: option<string>,
  creds:    option<string>,
  result:   option<string>,
}

let initial = {
  name: "",
  voters: [],
  choices: [],
  ballots: [],
  params: None,
  trustees: None,
  creds: None,
  uuid: None,
  result: None,
}

let to_json = (r) => {
  open! Json.Encode
  Unsafe.object({
    "name": string(r.name),
    "voters": array(Voter.to_json, r.voters),
    "choices": [],//array(Choice.to_json, r.choices),
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
      name: field.required(. "name", string),
      voters: field.required(. "voters", array(Voter.from_json)), // TODO: Make it optional
      choices: [],//field.required(. "choices", array(Choice.from_json)),
      ballots: field.required(. "ballots", array(Ballot.from_json)),
      uuid: field.required(. "uuid", option(string)),
      params: field.required(. "params", option(string)) -> Option.map(Belenios.Election.parse),
      trustees: field.required(. "trustees", option(string)),
      creds: field.required(. "creds", option(string)),
      result: field.required(. "result", option(string)),
    }
  })
  switch (json->Json.decode(decode)) {
    | Ok(result) => result
    | Error(error) => {
      raise(DecodeError({error}))
    }
  }
}

let get = (uuid) => {
  Webapi.Fetch.fetch(j`${Config.api_url}/elections/${uuid}`)
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
  let url = `${Config.api_url}/elections/${election.uuid->Option.getExn}/ballots`
  let payload = Ballot.to_json(ballot)
  X.post(url, payload)
}

let post_result = (election, result: string) => {
  let url = `${Config.api_url}/elections/${election.uuid->Option.getExn}/result`
  let payload = {
    let dict = Js.Dict.empty()
    Js.Dict.set(dict, "result", Js.Json.string(result))
    Js.Json.object_(dict)
  }
  X.post(url, payload)
}

let createBallot = (election : t, privateCredential : string, selection : array<int>) : Ballot.t => {
  let trustees = Belenios.Trustees.of_str(Option.getExn(election.trustees))

  let ciphertext =
    Belenios.Election.vote(Option.getExn(election.params), ~cred=privateCredential, ~selections=[selection], ~trustees)
    -> Belenios.Ballot.to_str

  let uuid = election.uuid -> Option.getExn
  let publicCredential = Belenios.Credentials.derive(~uuid, ~privateCredential)

  {
    electionUuid: election.uuid,
    ciphertext: Some(ciphertext),
    publicCredential,
    privateCredential
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
*/
