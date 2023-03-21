module Credentials = {
  @module("./belenios") @scope("belenios") @val external create: (string, int) => (array<string>, array<string>) = "makeCredentials"

  @module("./belenios") @scope("belenios") @val external derive: (~uuid: string, ~privateCredential: string) => (string) = "derive"

  type t = array<string>
  external parse: (string) => t = "JSON.parse"
  external stringify: (t) => string = "JSON.stringify"
}

module Trustees = {

  module Privkey = {
    type t

    external of_str: string => t = "%identity"
    external to_str: t => string = "%identity"
  }

  type t

  @module("./belenios") @scope("belenios") @val external create: () => (Privkey.t, t) = "genTrustee"

  let pubkey : (t) => string = %raw(`
    function(e) {
      var pubkey = JSON.parse(e)[0][1]["public_key"];
      console.log(pubkey);
      return pubkey;
    }
  `)

  external of_str: string => t = "%identity"
  external to_str: t => string = "%identity"
}

module Ballot = {
  type t

  external of_str: string => t = "%identity"
  external to_str: t => string = "%identity"

  module Parsed = {
    type t = {
      credential: string
    }
    external parse: (string) => t = "JSON.parse"
    external stringify: (t) => string = "JSON.stringify"
  }

  let setCredential : (t, string) => t = %raw(`function(t, credential) {
    var o = JSON.parse(t)
    o.credential = credential
    return JSON.stringify(o)
  }`)
}

module PartialDecryption = {
  type t1
  type t2

  external to_s1: (t1) => string = "%identity"
  external to_s2: (t2) => string = "%identity"
}

module Election = {
  type question_t = {
    question: string,
    max: int,
    min: int,
    blank: bool,
    answers: array<string>
  }

  type t = {
    version: string,
    uuid: string,
    name: string,
    description: string,
    group: string,
    public_key: string,
    questions: array<question_t>
  }

  type results_t = {
    result: array<array<int>>
  }

  external parse: (string) => t = "JSON.parse"
  external stringify: (t) => string = "JSON.stringify"

  @module("./belenios") @scope("belenios") @val external _create: (~name: string, ~description: string, ~choices: array<string>, ~trustees: Trustees.t) => string = "makeElection"
  @module("./belenios") @scope("belenios") @val external _vote: (string, ~cred: string, ~selections: array<array<int>>, ~trustees: Trustees.t) => Ballot.t = "encryptBallot"
  @module("./belenios") @scope("belenios") @val external _decrypt: (string, array<Ballot.t>, Trustees.t, array<string>, Trustees.Privkey.t) => (PartialDecryption.t1, PartialDecryption.t2) = "decrypt"
  @module("./belenios") @scope("belenios") @val external _result: (string, array<Ballot.t>, Trustees.t, array<string>, PartialDecryption.t1, PartialDecryption.t2) => (string) = "result"

  let create = (~name, ~description, ~choices, ~trustees) => parse(_create(~name, ~description, ~choices, ~trustees))
  let vote    = (o) => _vote(stringify(o))
  let decrypt = (o) => _decrypt(stringify(o))

  external parseResults : (string) => results_t = "JSON.parse"
  let result  = (o) => _result(stringify(o))

  let scores : (string) => array<int> = (s) =>
    Option.getExn(parseResults(s).result[0])

  let answers = (params) =>
    Array.getExn(params.questions, 0).answers
}
