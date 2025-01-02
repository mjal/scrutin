type t = {
  setup: Setup.t,
  ballots: array<Ballot.t>,
  encryptedTally: EncryptedTally.t,
  partialDecryptions: array<PartialDecryption.t>,
  result: Result_.t
}

