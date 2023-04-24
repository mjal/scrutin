type t = {
  electionId: string,
  previousId: option<string>,
  electionPublicKey: string,
  voterPublicKey: string,
  ciphertext: option<string>,
  pubcred: option<string>,
}

external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"

let new = (election:Election.t, electionId, voterPublicKey) => {
  {
    electionId,
    previousId: None,
    ciphertext: None,
    pubcred: None,
    electionPublicKey: election.ownerPublicKey,
    voterPublicKey
  }
}

let make = (ballot, previousId, election: Election.t, selection: array<int>) => {
  let trustees = Belenios.Trustees.of_str(election.trustees)
  let params = Belenios.Election.parse(election.params)

  //let pubcred = Belenios.Credentials.derive(~uuid=params.uuid, ~:rivcred)
  let (pubcreds, privcreds) = Belenios.Credentials.create(params.uuid, 1)
  let (pubcred, privcred) = (Array.getExn(pubcreds, 0), Array.getExn(privcreds, 0))

  let ciphertext =
    Belenios.Election.vote(
      params,
      ~cred=privcred,
      ~selections=[selection],
      ~trustees,
    )->Belenios.Ballot.to_str

  {
    ...ballot,
    previousId,
    pubcred: Some(pubcred),
    ciphertext: Some(ciphertext),
  }
}
