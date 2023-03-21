type t = {
  electionId: string,
  previousTx: option<string>, // TODO: Rename -> ballotId

  electionPublicKey: string,
  voterPublicKey:    string,

  ciphertext: option<string>,
  pubcred: option<string>,
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (ballot, election:Election.t, selection:array<int>) => {
  let trustees = Belenios.Trustees.of_str(election.trustees)
  let params = Belenios.Election.parse(election.params)

  //let pubcred = Belenios.Credentials.derive(~uuid=params.uuid, ~:rivcred)
  let (pubcreds, privcreds) = Belenios.Credentials.create(params.uuid, 1)
  let (pubcred, privcred) =
    (Array.getExn(pubcreds, 0), Array.getExn(privcreds, 0))

  let ciphertext =
    Belenios.Election.vote(params,
      ~cred=privcred,
      ~selections=[selection],
      ~trustees)
    -> Belenios.Ballot.to_str

  {
    ...ballot,
    pubcred: Some(pubcred),
    ciphertext: Some(ciphertext)
  }
}

