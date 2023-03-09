type t = {
  electionTx: string,
  previousTx: option<string>,
  owners:     array<string>,
  ciphertext: option<string>,
  pubcred: option<string>,
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (ballot, election:Election.t, selection:array<int>) => {
  let trustees = Belenios.Trustees.of_str(election.trustees)
  let params = Belenios.Election.parse(election.params)


  //let pubcred = Belenios.Credentials.derive(~uuid=params.uuid, ~:rivcred)
  let ([pubcred], [privcred]) = Belenios.Credentials.create(params.uuid, 1)

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

