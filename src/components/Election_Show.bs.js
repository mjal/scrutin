// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../helpers/X.bs.js";
import * as Core from "../Core.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../helpers/Config.bs.js";
import * as Context from "../helpers/Context.bs.js";
import * as Identity from "../model/Identity.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Transaction from "../model/Transaction.bs.js";
import * as ReactNative from "react-native";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as ReactNativePaper from "react-native-paper";

function Election_Show$MessageModal(Props) {
  var message = Props.message;
  var visible = Props.visible;
  var setVisible = Props.setVisible;
  var hexSecretKey = Props.hexSecretKey;
  var match = Context.use(undefined);
  var dispatch = match[1];
  return React.createElement(ReactNativePaper.Portal, {
              children: React.createElement(ReactNativePaper.Modal, {
                    visible: visible,
                    onDismiss: (function (param) {
                        Curry._1(setVisible, (function (param) {
                                return false;
                              }));
                      }),
                    children: React.createElement(ReactNative.View, {
                          style: ReactNative.StyleSheet.flatten([
                                X.styles.modal,
                                X.styles.layout
                              ]),
                          testID: "choice-modal",
                          children: null
                        }, React.createElement(ReactNativePaper.Text, {
                              children: message
                            }), React.createElement(ReactNativePaper.Button, {
                              onPress: (function (param) {
                                  Curry._1(dispatch, {
                                        TAG: /* Identity_Add */1,
                                        _0: Identity.make2(hexSecretKey)
                                      });
                                }),
                              children: "Add identity (dev)"
                            }))
                  })
            });
}

var MessageModal = {
  make: Election_Show$MessageModal
};

function Election_Show(Props) {
  var eventHash = Props.eventHash;
  var match = Context.use(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setEmail = match$1[1];
  var email = match$1[0];
  var match$2 = React.useState(function () {
        return "";
      });
  var election = Belt_MapString.getExn(state.cached_elections, eventHash);
  var publicKey = election.ownerPublicKey;
  var match$3 = React.useState(function () {
        return false;
      });
  var match$4 = React.useState(function () {
        return "";
      });
  var ballots = Belt_Array.keep(Belt_Array.keep(state.txs, (function (tx) {
              return tx.eventType === "ballot";
            })), (function (tx) {
          var ballot = Transaction.SignedBallot.unwrap(tx);
          return ballot.electionTx === eventHash;
        }));
  var nbBallots = ballots.length;
  var addBallot = function (param) {
    var id = Identity.make(undefined);
    var hexSecretKey = Belt_Option.getExn(id.hexSecretKey);
    var ballot_electionPublicKey = election.ownerPublicKey;
    var ballot_voterPublicKey = id.hexPublicKey;
    var ballot = {
      electionTx: eventHash,
      previousTx: undefined,
      electionPublicKey: ballot_electionPublicKey,
      voterPublicKey: ballot_voterPublicKey,
      ciphertext: undefined,
      pubcred: undefined
    };
    var electionOwner = Belt_Option.getExn(Belt_Array.getBy(state.ids, (function (id) {
                return id.hexPublicKey === election.ownerPublicKey;
              })));
    var tx = Transaction.SignedBallot.make(ballot, electionOwner);
    Curry._1(dispatch, {
          TAG: /* Transaction_Add */2,
          _0: tx
        });
    var message = "\n      Hello !\n      Vous êtes invité à une election.\n      Cliquez ici pour voter :\n      https://scrutin.app/ballots/" + tx.eventHash + "#" + hexSecretKey + "\n    ";
    var time = Date.now() | 0;
    var hexTime = time.toString(16);
    var hexSignedTime = Identity.signHex(electionOwner, hexTime);
    var dict = {};
    dict["email"] = email;
    dict["subject"] = "Vous êtes invité à un election";
    dict["text"] = message;
    dict["time"] = String(time);
    dict["hexSignedTime"] = hexSignedTime;
    X.post("" + Config.api_url + "/proxy_email", dict);
  };
  var onPress = function (param) {
    Curry._1(dispatch, {
          TAG: /* Navigate */0,
          _0: {
            TAG: /* Identity_Show */1,
            _0: publicKey
          }
        });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.List.Section, {
                  title: "Election",
                  children: null
                }, React.createElement(ReactNativePaper.List.Item, {
                      title: "Event Hash",
                      description: eventHash
                    }), React.createElement(ReactNativePaper.List.Item, {
                      onPress: onPress,
                      title: "Owner Public Key",
                      description: publicKey
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Params",
                      description: election.params
                    }), React.createElement(ReactNativePaper.List.Item, {
                      title: "Trustees",
                      description: election.trustees
                    })), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ReactNativePaper.Title, {
                  style: X.styles.title,
                  children: "Invite someone"
                }), React.createElement(ReactNativePaper.TextInput, {
                  mode: "flat",
                  label: "Email",
                  value: email,
                  onChangeText: (function (text) {
                      Curry._1(setEmail, (function (param) {
                              return text;
                            }));
                    })
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "outlined",
                  onPress: addBallot,
                  children: "Add as voter"
                }), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ReactNativePaper.List.Section, {
                  title: "" + String(nbBallots) + " ballots",
                  children: Belt_Array.map(ballots, (function (tx) {
                          Transaction.SignedBallot.unwrap(tx);
                          return React.createElement(ReactNativePaper.List.Item, {
                                      onPress: (function (param) {
                                          Curry._1(dispatch, {
                                                TAG: /* Navigate */0,
                                                _0: {
                                                  TAG: /* Ballot_Show */2,
                                                  _0: tx.eventHash
                                                }
                                              });
                                        }),
                                      title: "Ballot " + tx.eventHash + "",
                                      key: tx.eventHash
                                    });
                        }))
                }), React.createElement(Election_Show$MessageModal, {
                  message: match$4[0],
                  visible: match$3[0],
                  setVisible: match$3[1],
                  hexSecretKey: match$2[0]
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "outlined",
                  onPress: (function (param) {
                      Core.Election.tally(eventHash, state, dispatch);
                    }),
                  children: "Tally"
                }));
}

var make = Election_Show;

export {
  MessageModal ,
  make ,
}
/* X Not a pure module */
