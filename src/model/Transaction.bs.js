// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../helpers/X.bs.js";
import * as Config from "../helpers/Config.bs.js";
import * as Identity from "./Identity.bs.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as SjclWithAll from "sjcl-with-all";
import * as Json$JsonCombinators from "rescript-json-combinators/src/Json.bs.js";
import * as Json_Decode$JsonCombinators from "rescript-json-combinators/src/Json_Decode.bs.js";
import * as AsyncStorage from "@react-native-async-storage/async-storage";

function hash(str) {
  return SjclWithAll.codec.hex.fromBits(SjclWithAll.hash.sha256.hash(str));
}

function make(election, owner) {
  var content = JSON.stringify(election);
  var contentHash = SjclWithAll.codec.hex.fromBits(SjclWithAll.hash.sha256.hash(content));
  return {
          type_: "election",
          content: content,
          contentHash: contentHash,
          publicKey: owner.hexPublicKey,
          signature: Identity.signHex(owner, contentHash)
        };
}

function unwrap(tx) {
  return JSON.parse(tx.content);
}

var SignedElection = {
  make: make,
  unwrap: unwrap
};

function make$1(ballot, owner) {
  var content = JSON.stringify(ballot);
  var contentHash = SjclWithAll.codec.hex.fromBits(SjclWithAll.hash.sha256.hash(content));
  return {
          type_: "ballot",
          content: content,
          contentHash: contentHash,
          publicKey: owner.hexPublicKey,
          signature: Identity.signHex(owner, contentHash)
        };
}

function unwrap$1(tx) {
  return JSON.parse(tx.content);
}

var SignedBallot = {
  make: make$1,
  unwrap: unwrap$1
};

function from_json(json) {
  var decode = Json_Decode$JsonCombinators.object(function (field) {
        var match = field.required("type_", Json_Decode$JsonCombinators.string);
        var type_;
        switch (match) {
          case "ballot" :
              type_ = "ballot";
              break;
          case "election" :
              type_ = "election";
              break;
          default:
            type_ = "election";
        }
        return {
                type_: type_,
                content: field.required("content", Json_Decode$JsonCombinators.string),
                contentHash: field.required("contentHash", Json_Decode$JsonCombinators.string),
                publicKey: field.required("publicKey", Json_Decode$JsonCombinators.string),
                signature: field.required("signature", Json_Decode$JsonCombinators.string)
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

function to_json(r) {
  var match = r.type_;
  var type_ = match === "ballot" ? "ballot" : "election";
  return {
          type_: type_,
          content: r.content,
          contentHash: r.contentHash,
          publicKey: r.publicKey,
          signature: r.signature
        };
}

var storageKey = "transactions";

function fetch_all(param) {
  return AsyncStorage.default.getItem(storageKey).then(function (prim) {
                  if (prim === null) {
                    return ;
                  } else {
                    return Caml_option.some(prim);
                  }
                }).then(function (__x) {
                return Belt_Option.map(__x, (function (prim) {
                              return JSON.parse(prim);
                            }));
              }).then(function (__x) {
              return Belt_Option.getWithDefault(__x, []);
            });
}

function store_all(txs) {
  AsyncStorage.default.setItem(storageKey, JSON.stringify(txs));
}

function clear(param) {
  AsyncStorage.default.removeItem(storageKey);
}

function broadcast(tx) {
  return X.post("" + Config.api_url + "/transactions", to_json(tx));
}

export {
  hash ,
  SignedElection ,
  SignedBallot ,
  from_json ,
  to_json ,
  storageKey ,
  fetch_all ,
  store_all ,
  clear ,
  broadcast ,
}
/* X Not a pure module */
