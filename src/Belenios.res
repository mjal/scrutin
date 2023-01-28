module Credentials = {
  @module("./belenios_jslib2") @scope("belenios") @val external create: (string, int) => (array<string>, array<string>) = "makeCredentials"
}

module Trustees = {
  type t
  module Privkey = { type t }
  @module("./belenios_jslib2") @scope("belenios") @val external create: () => (Privkey.t, t) = "genTrustee"
}

module Ballot = {
  type t
}

module Election = {
  type t

  @module("./belenios_jslib2") @scope("belenios") @val external create: (string, string, array<string>, Trustees.t) => t = "makeElection"
  @module("./belenios_jslib2") @scope("belenios") @val external vote: (t, string, array<array<int>>, Trustees.t) => Ballot.t = "encryptBallot"

  let uuid : (t) => string = %raw(`
    function(e) {
      return JSON.parse(e)["uuid"];
    }
  `)

}