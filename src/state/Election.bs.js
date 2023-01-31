// Generated by ReScript, PLEASE EDIT WITH CARE
/* eslint-disable default-case */
/* eslint-disable no-throw-literal */

import * as X from "../X.bs.js";
import * as Voter from "./Voter.bs.js";
import * as Ballot from "./Ballot.bs.js";
import * as Choice from "./Choice.bs.js";
import * as Config from "../Config.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as SentBallot from "./SentBallot.bs.js";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as Json$JsonCombinators from "rescript-json-combinators/src/Json.bs.js";
import * as Json_Decode$JsonCombinators from "rescript-json-combinators/src/Json_Decode.bs.js";
import * as Json_Encode$JsonCombinators from "rescript-json-combinators/src/Json_Encode.bs.js";

var initial_voters = [];

var initial_choices = [];

var initial_ballots = [];

var initial = {
  id: 0,
  name: "",
  voters: initial_voters,
  choices: initial_choices,
  ballots: initial_ballots,
  belenios_params: ""
};

function to_json(r) {
  return {
          id: r.id,
          name: r.name,
          voters: Json_Encode$JsonCombinators.array(Voter.to_json, r.voters),
          choices: Json_Encode$JsonCombinators.array(Choice.to_json, r.choices),
          ballots: Json_Encode$JsonCombinators.array(Ballot.to_json, r.ballots)
        };
}

var DecodeError = /* @__PURE__ */Caml_exceptions.create("Election.DecodeError");

function from_json(json) {
  var decode = Json_Decode$JsonCombinators.object(function (field) {
        return {
                id: field.required("id", Json_Decode$JsonCombinators.$$int),
                name: field.required("name", Json_Decode$JsonCombinators.string),
                voters: field.required("voters", Json_Decode$JsonCombinators.array(Voter.from_json)),
                choices: field.required("choices", Json_Decode$JsonCombinators.array(Choice.from_json)),
                ballots: field.required("ballots", Json_Decode$JsonCombinators.array(Ballot.from_json)),
                belenios_params: field.required("belenios_params", Json_Decode$JsonCombinators.string)
              };
      });
  var result = Json$JsonCombinators.decode(json, decode);
  if (result.TAG === /* Ok */0) {
    return result._0;
  }
  throw {
        RE_EXN_ID: Json_Decode$JsonCombinators.DecodeError,
        _1: result._0,
        Error: new Error()
      };
}

function get(id) {
  return fetch("" + Config.api_url + ("/elections/" + id)).then(function (prim) {
              return prim.json();
            });
}

function getAll(param) {
  return fetch("" + Config.api_url + "/elections").then(function (prim) {
              return prim.json();
            });
}

function post(election) {
  return X.post("" + Config.api_url + "/elections/", to_json(election));
}

function post_ballot(election, ballot) {
  var election_id = String(election.id);
  return X.post("" + Config.api_url + "/elections/" + election_id + "/ballots", SentBallot.to_json(ballot));
}

function reducer(election, action) {
  if (typeof action === "number") {
    return election;
  }
  switch (action.TAG | 0) {
    case /* SetElectionName */0 :
        return {
                id: election.id,
                name: action._0,
                voters: election.voters,
                choices: election.choices,
                ballots: election.ballots,
                belenios_params: election.belenios_params
              };
    case /* SetElectionBeleniosParams */1 :
        return {
                id: election.id,
                name: election.name,
                voters: election.voters,
                choices: election.choices,
                ballots: election.ballots,
                belenios_params: action._0
              };
    case /* AddVoter */3 :
        return {
                id: election.id,
                name: election.name,
                voters: Belt_Array.concat(election.voters, [{
                        id: 0,
                        email: action._0
                      }]),
                choices: election.choices,
                ballots: election.ballots,
                belenios_params: election.belenios_params
              };
    case /* RemoveVoter */4 :
        var email = action._0;
        return {
                id: election.id,
                name: election.name,
                voters: Belt_Array.keep(election.voters, (function (voter) {
                        return voter.email !== email;
                      })),
                choices: election.choices,
                ballots: election.ballots,
                belenios_params: election.belenios_params
              };
    case /* AddChoice */5 :
        return {
                id: election.id,
                name: election.name,
                voters: election.voters,
                choices: Belt_Array.concat(election.choices, [{
                        id: 0,
                        name: action._0
                      }]),
                ballots: election.ballots,
                belenios_params: election.belenios_params
              };
    case /* RemoveChoice */6 :
        var name = action._0;
        return {
                id: election.id,
                name: election.name,
                voters: election.voters,
                choices: Belt_Array.keep(election.choices, (function (e) {
                        return e.name !== name;
                      })),
                ballots: election.ballots,
                belenios_params: election.belenios_params
              };
    default:
      return election;
  }
}

export {
  initial ,
  to_json ,
  DecodeError ,
  from_json ,
  get ,
  getAll ,
  post ,
  post_ballot ,
  reducer ,
}
/* X Not a pure module */
