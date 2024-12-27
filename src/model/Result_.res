type t = {
  result: array<array<int>>
};

@module("sirona") @scope("Result") @val
external generate : (Setup.t, EncryptedTally.t, array<PartialDecryption.t>) => t = "generate"
