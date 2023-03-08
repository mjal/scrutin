type t = {
  electionTx: string,
  previousTx: option<string>,
  owners:     array<string>,
  ciphertext: option<string>,
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (ballot, election:Election.t, selection:array<int>) => {
  let trustees = Belenios.Trustees.of_str(election.trustees)
  let params = Belenios.Election.parse(election.params)

  let privateCredential = ""
  //let publicCredential = Belenios.Credentials.derive(~uuid=params.uuid, ~privateCredential)

  let ciphertext =
    Belenios.Election.vote(params,
      ~cred=privateCredential,
      ~selections=[selection],
      ~trustees)
    -> Belenios.Ballot.to_str

  {
    ...ballot,
    ciphertext: Some(ciphertext)
  }
}

