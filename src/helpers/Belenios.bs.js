// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belenios_jslib2 from "./belenios_jslib2";

function create(prim0, prim1) {
  return Belenios_jslib2.belenios.makeCredentials(prim0, prim1);
}

function derive(prim0, prim1) {
  return Belenios_jslib2.belenios.derive(prim0, prim1);
}

var Credentials = {
  create: create,
  derive: derive
};

var Privkey = {};

function create$1(prim) {
  return Belenios_jslib2.belenios.genTrustee();
}

var pubkey = (function(e) {
      var pubkey = JSON.parse(e)[0][1]["public_key"];
      console.log(pubkey);
      return pubkey;
    });

var Trustees = {
  Privkey: Privkey,
  create: create$1,
  pubkey: pubkey
};

var Parsed = {};

var setCredential = (function(t, credential) {
    var o = JSON.parse(t)
    o.credential = credential
    return JSON.stringify(o)
  });

var Ballot = {
  Parsed: Parsed,
  setCredential: setCredential
};

var PartialDecryption = {};

function _create(prim0, prim1, prim2, prim3) {
  return Belenios_jslib2.belenios.makeElection(prim0, prim1, prim2, prim3);
}

function _vote(prim0, prim1, prim2, prim3) {
  return Belenios_jslib2.belenios.encryptBallot(prim0, prim1, prim2, prim3);
}

function _decrypt(prim0, prim1, prim2, prim3, prim4) {
  return Belenios_jslib2.belenios.decrypt(prim0, prim1, prim2, prim3, prim4);
}

function _result(prim0, prim1, prim2, prim3, prim4, prim5) {
  return Belenios_jslib2.belenios.result(prim0, prim1, prim2, prim3, prim4, prim5);
}

function create$2(name, description, choices, trustees) {
  return JSON.parse(_create(name, description, choices, trustees));
}

function vote(o) {
  var partial_arg = JSON.stringify(o);
  return function (param, param$1, param$2) {
    return _vote(partial_arg, param, param$1, param$2);
  };
}

function decrypt(o) {
  var partial_arg = JSON.stringify(o);
  return function (param, param$1, param$2, param$3) {
    return _decrypt(partial_arg, param, param$1, param$2, param$3);
  };
}

function result(o) {
  var partial_arg = JSON.stringify(o);
  return function (param, param$1, param$2, param$3, param$4) {
    return _result(partial_arg, param, param$1, param$2, param$3, param$4);
  };
}

function answers(params) {
  return Belt_Array.getExn(params.questions, 0).answers;
}

var Election = {
  _create: _create,
  _vote: _vote,
  _decrypt: _decrypt,
  _result: _result,
  create: create$2,
  vote: vote,
  decrypt: decrypt,
  result: result,
  answers: answers
};

export {
  Credentials ,
  Trustees ,
  Ballot ,
  PartialDecryption ,
  Election ,
}
/* ./belenios_jslib2 Not a pure module */
