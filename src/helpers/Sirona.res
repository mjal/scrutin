module Trustee = {
  type t

  @module("sirona") @scope("Trustee") @val
  external create: () => t = "generate"
}

module QuestionH = {
  type t = {
    answers: array<string>,
    blank?: bool,
    min: int,
    max: int,
    question: string
  };
}

module Election = {
  type t = {
    version: int,
    description: string,
    name: string,
    group: string,
    //public_key: Point.t;
    //questions: Question.t[];
    uuid: string,
    administrator?: string,
    credential_authority?: string
  }

  @module("sirona") @scope("Election") @val
  external create: (string, int) => t = "create"
}

//@module("react-native") @scope("Share") @val
//let genTrustee: string => string = %raw(`
//  function(e) {
//    const Trustee = require("sirona/dist/Trustee)
//    console.log(Trustee.generate()[1][1].pok)
//    return "";
//  }
//`)
