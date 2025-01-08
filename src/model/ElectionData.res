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

let parse = (o: serialized_t) : t => {
  {
    setup: Setup.parse(o.setup),
    ballots: o.ballots,
    encryptedTally: o.encryptedTally,
    partialDecryptions: o.partialDecryptions,
    result: o.result
  }
}
