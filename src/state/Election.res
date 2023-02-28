type t = {
  params:   string,
  trustees: string,
  ownerPublicKey: string
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (name, description, choices, ownerPublicKey) => {
  let (privkey, trustees) = Belenios.Trustees.create()
  Store.Trustee.add({pubkey: Belenios.Trustees.pubkey(trustees), privkey})

  let params =
    Belenios.Election._create(~name, ~description, ~choices, ~trustees)

  {
    params,
    trustees: Belenios.Trustees.to_str(trustees),
    ownerPublicKey
  }
}

/*
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
*/
