type t = {
  params:   string,
  trustees: string,
  ownerPublicKey: string
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (name, description, choices, ownerPublicKey, trustee:Trustee.t) => {
  let trustees = trustee.trustees

  let params =
    Belenios.Election._create(~name, ~description, ~choices, ~trustees)

  {
    params,
    trustees: Belenios.Trustees.to_str(trustees),
    ownerPublicKey
  }
}

let answers = (election) =>
  Belenios.Election.answers(Belenios.Election.parse(election.params))

let name = (election) =>
  Belenios.Election.parse(election.params).name

let description = (election) =>
  Belenios.Election.parse(election.params).description
