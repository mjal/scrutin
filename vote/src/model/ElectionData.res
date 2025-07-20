type t = {
  setup: Setup.t,
  ballots: array<Ballot.t>,
  encryptedTally: option<EncryptedTally.t>,
  partialDecryptions: array<PartialDecryption.t>,
  result: option<Result_.t>
}

type serialized_t = {
  setup: Setup.serialized_t,
  ballots: array<Ballot.t>,
  encryptedTally: option<EncryptedTally.t>,
  partialDecryptions: array<PartialDecryption.t>,
  result: option<Result_.t>
}

type election_dates_t = { startDate?: string, endDate?: string }
let parse = (o: serialized_t) : t => {
  let dates : election_dates_t = Obj.magic(o.setup.election)
  let startDate = switch dates.startDate {
  | Some(str) => Some(Js.Date.fromString(str))
  | None => None
  }
  let endDate = switch dates.endDate {
  | Some(str) => Some(Js.Date.fromString(str))
  | None => None
  }
  let setup = Setup.parse(o.setup)
  let setup = {
    ...setup,
    election: {
      ...setup.election,
      ?startDate,
      ?endDate
    }
  }

  {
    setup,
    ballots: o.ballots,
    encryptedTally: o.encryptedTally,
    partialDecryptions: o.partialDecryptions,
    result: o.result
  }
}
