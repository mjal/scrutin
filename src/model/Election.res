type t = {
  // First version of the election (None for new elections)
  electionId: option<string>,

  // Public keys of election admins (can update the election)
  adminIds: array<string>,

  // Public keys of voters (can sign ballots)
  voterIds: array<string>,

  // Election parameters
  params: string,
  trustees: string,

  // Tally parameters
  pda: option<string>,
  pdb: option<string>,
  result: option<string>
}

external parse: string => t = "JSON.parse"
external stringify: t => string = "JSON.stringify"

let answers = election => Belenios.Election.answers(Belenios.Election.parse(election.params))
let choices = answers

let name = election => Belenios.Election.parse(election.params).name

let description = election => Belenios.Election.parse(election.params).description
