// HACK: Required for netlify compile
%%raw(`/* eslint-disable default-case */`)
%%raw(`/* eslint-disable no-throw-literal */`)

type t = {
  id: int,
  name: string,
  voters: array<Voter.t>,
  choices: array<Choice.t>,
  ballots: array<Ballot.t>,
  params: string, // TODO: option<string> or option<Belenios.Election.t>
  trustees: string, // TODO: option
  creds: string // TODO: option
}

let initial = {
  id: 0,
  name: "",
  voters: [],
  choices: [],
  ballots: [],
  params: "",
  trustees: "",
  creds: ""
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
    "creds": string(r.creds)
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
    creds: field.required(. "creds", string)
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

let post_ballot = (election, ballot: SentBallot.t) => {
  let election_id = election.id -> Int.toString
  X.post(`${Config.api_url}/elections/${election_id}/ballots`, ballot -> SentBallot.to_json)
}

let reducer = (election, action) => {
  switch(action: Action.t) {
    | SetElectionName(name) => {
      ...election,
      name: name
    }
    | SetElectionBelenios(params, trustees, creds) => {
      ...election,
      params, trustees, creds
    }
    // TODO: Generate unique negative index. Use it for RemoveVoter and index=
    | AddVoter(email) => {
      ...election,
      voters: election.voters -> Array.concat([{ id: 0, email: email, pubCred: "", privCred: "" }: Voter.t])
    }
    | RemoveVoter(email) => {
      ...election,
      voters: election.voters -> Array.keep(voter => voter.email != email)
    }
    // TODO: Generate unique negative index. Use it for RemoveChoice and index=
    | AddChoice(name) => {
      ...election,
      choices: election.choices -> Array.concat([{ id: 0, name: name }: Choice.t])
    }
    | RemoveChoice(name) => {
      ...election,
      choices: election.choices -> Array.keep(e => e.name != name)
    }
    | _ => election
  }
}
