// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belenios from "../Belenios.bs.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Election from "./Election.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactNative from "react-native";
import * as AsyncStorage from "@react-native-async-storage/async-storage";

function loadElections(dispatch) {
  Election.getAll(undefined).then(function (res) {
        var json_array = Js_json.decodeArray(res);
        if (json_array !== undefined) {
          return Curry._1(dispatch, {
                      TAG: /* Election_LoadAll */9,
                      _0: json_array
                    });
        } else {
          return Curry._1(dispatch, {
                      TAG: /* Election_LoadAll */9,
                      _0: []
                    });
        }
      });
}

function loadElection(id, dispatch) {
  Election.get(id).then(function (o) {
        return Curry._1(dispatch, {
                    TAG: /* Election_Load */8,
                    _0: o
                  });
      });
}

function createElection(election, dispatch) {
  var match = Belenios.Trustees.create(undefined);
  var trustees = match[1];
  AsyncStorage.default.setItem(Belenios.Trustees.pubkey(trustees), match[0]);
  var params = Belenios.Election.create(election.name, "description", Belt_Array.map(election.choices, (function (o) {
              return o.name;
            })), trustees);
  var match$1 = Belenios.Credentials.create(params.uuid, election.voters.length);
  var pubcreds = match$1[0];
  var creds = Belt_Array.zip(pubcreds, match$1[1]);
  var voters = Belt_Array.map(Belt_Array.zip(election.voters, creds), (function (param) {
          var match = param[1];
          var voterWithoutCred = param[0];
          return {
                  id: voterWithoutCred.id,
                  email: voterWithoutCred.email,
                  privCred: match[1],
                  pubCred: match[0]
                };
        }));
  var election_id = election.id;
  var election_name = election.name;
  var election_choices = election.choices;
  var election_ballots = election.ballots;
  var election_uuid = params.uuid;
  var election_params = params;
  var election_trustees = trustees;
  var election_creds = JSON.stringify(pubcreds);
  var election_result = election.result;
  var election$1 = {
    id: election_id,
    name: election_name,
    voters: voters,
    choices: election_choices,
    ballots: election_ballots,
    uuid: election_uuid,
    params: election_params,
    trustees: election_trustees,
    creds: election_creds,
    result: election_result
  };
  Election.post(election$1).then(function (prim) {
          return prim.json();
        }).then(function (res) {
        Curry._1(dispatch, {
              TAG: /* Election_Load */8,
              _0: res
            });
        var id = Election.from_json(res).id;
        Curry._1(dispatch, {
              TAG: /* Navigate */11,
              _0: {
                TAG: /* ElectionBooth */1,
                _0: id
              }
            });
      });
}

function ballotCreate(election, token, selection, dispatch) {
  var ballot = Election.createBallot(election, token, selection);
  Election.post_ballot(election, ballot).then(function (res) {
        console.log(res);
      });
}

function publishElectionResult(election, result, dispatch) {
  Election.post_result(election, result).then(function (param) {
        Curry._1(dispatch, {
              TAG: /* Election_SetResult */1,
              _0: result
            });
      });
}

function goToUrl(dispatch) {
  ReactNative.Linking.getInitialURL().then(function (res) {
        var sUrl = Belt_Option.getWithDefault(res === null ? undefined : Caml_option.some(res), "");
        var url = new URL(sUrl);
        var oResult = /^\/elections\/(.*)/g.exec(url.pathname);
        var capture;
        if (oResult !== null) {
          var str = Belt_Array.get(oResult, 1);
          capture = str !== undefined ? Caml_option.nullable_to_opt(Caml_option.valFromOption(str)) : undefined;
        } else {
          capture = undefined;
        }
        if (capture !== undefined) {
          return Curry._1(dispatch, {
                      TAG: /* Navigate */11,
                      _0: {
                        TAG: /* ElectionBooth */1,
                        _0: Belt_Option.getWithDefault(Belt_Int.fromString(capture), 0)
                      }
                    });
        }
        
      });
}

export {
  loadElections ,
  loadElection ,
  createElection ,
  ballotCreate ,
  publishElectionResult ,
  goToUrl ,
}
/* Belenios Not a pure module */
