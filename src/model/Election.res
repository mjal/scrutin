type t = {
  previousId: option<string>,
  params:   string,
  trustees: string,
  ownerPublicKey: string,
  pda: option<string>,
  pdb: option<string>,
  result: option<string>
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (name, description, choices, ownerPublicKey, trustee:Trustee.t) => {
  let trustees = trustee.trustees

  let params =
    Belenios.Election._create(~name, ~description, ~choices, ~trustees)

  {
    previousId: None,
    params,
    trustees: Belenios.Trustees.to_str(trustees),
    ownerPublicKey,
    pda: None,
    pdb: None,
    result: None
  }
}

let answers = (election) =>
  Belenios.Election.answers(Belenios.Election.parse(election.params))
let choices = answers

let name = (election) =>
  Belenios.Election.parse(election.params).name

let description = (election) =>
  Belenios.Election.parse(election.params).description
