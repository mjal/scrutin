// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../helpers/X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../helpers/Context.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Transaction from "../model/Transaction.bs.js";
import * as ReactNativePaper from "react-native-paper";

function Transaction_Home$Item(Props) {
  var tx = Props.tx;
  var match = Context.use(undefined);
  var dispatch = match[1];
  var match$1 = tx.type_;
  var description = match$1 === "ballot" ? "Ballot" : (
      match$1 === "tally" ? "Tally" : "Election"
    );
  var onPress = function (param) {
    var match = tx.type_;
    if (match === "ballot") {
      return Curry._1(dispatch, {
                  TAG: /* Navigate */0,
                  _0: {
                    TAG: /* Ballot_Show */2,
                    _0: tx.contentHash
                  }
                });
    }
    if (match !== "tally") {
      return Curry._1(dispatch, {
                  TAG: /* Navigate */0,
                  _0: {
                    TAG: /* Election_Show */0,
                    _0: tx.contentHash
                  }
                });
    }
    var tally = Transaction.SignedTally.unwrap(tx);
    Curry._1(dispatch, {
          TAG: /* Navigate */0,
          _0: {
            TAG: /* Election_Show */0,
            _0: tally.electionTx
          }
        });
  };
  return React.createElement(ReactNativePaper.Card, {
              children: React.createElement(ReactNativePaper.List.Item, {
                    onPress: onPress,
                    title: "type",
                    description: description,
                    key: tx.contentHash
                  })
            });
}

var Item = {
  make: Transaction_Home$Item
};

function Transaction_Home(Props) {
  var match = Context.use(undefined);
  var dispatch = match[1];
  var clear = function (param) {
    Transaction.clear(undefined);
    Curry._1(dispatch, /* Reset */0);
  };
  return React.createElement(ReactNativePaper.List.Section, {
              title: "Transactions",
              children: null
            }, Belt_Array.map(match[0].txs, (function (tx) {
                    return React.createElement(Transaction_Home$Item, {
                                tx: tx,
                                key: tx.contentHash
                              });
                  })), React.createElement(X.Title.make, {
                  children: "-"
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "contained",
                  onPress: clear,
                  children: "Clear"
                }));
}

var make = Transaction_Home;

export {
  Item ,
  make ,
}
/* X Not a pure module */
