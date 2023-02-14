// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../state/Context.bs.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";
import * as ElectionNew_VoterList from "./ElectionNew_VoterList.bs.js";
import * as ElectionNew_ChoiceList from "./ElectionNew_ChoiceList.bs.js";

function ElectionNew(Props) {
  var match = Context.use(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  var setVisibleVoter = match$1[1];
  var match$2 = React.useState(function () {
        return false;
      });
  var setVisibleChoice = match$2[1];
  React.useEffect((function () {
          Curry._1(dispatch, {
                TAG: /* Election_AddChoice */5,
                _0: "Choice 1"
              });
          Curry._1(dispatch, {
                TAG: /* Election_AddChoice */5,
                _0: "Choice 2"
              });
          Curry._1(dispatch, {
                TAG: /* Election_AddVoter */3,
                _0: "some1@this-email-doesnt-exist-ty67.com"
              });
        }), []);
  var onSubmit = function (param) {
    if (state.election.choices.length < 2) {
      return Curry._1(setVisibleChoice, (function (param) {
                    return true;
                  }));
    } else if (state.election.voters.length < 1) {
      return Curry._1(setVisibleVoter, (function (param) {
                    return true;
                  }));
    } else {
      return Curry._1(dispatch, /* Election_Post */1);
    }
  };
  return React.createElement(ReactNative.View, {
              children: null
            }, React.createElement(ReactNativePaper.TextInput, {
                  mode: "flat",
                  label: "Nom de l'élection",
                  value: state.election.name,
                  onChangeText: (function (text) {
                      Curry._1(dispatch, {
                            TAG: /* Election_SetName */2,
                            _0: text
                          });
                    }),
                  testID: "election-name"
                }), React.createElement(ElectionNew_ChoiceList.make, {}), React.createElement(ElectionNew_VoterList.make, {}), React.createElement(ReactNativePaper.Button, {
                  mode: "contained",
                  onPress: onSubmit,
                  children: React.createElement(ReactNativePaper.Text, {
                        children: "Create election"
                      })
                }), React.createElement(ReactNativePaper.Portal, {
                  children: null
                }, React.createElement(ReactNativePaper.Snackbar, {
                      onDismiss: (function (param) {
                          Curry._1(setVisibleChoice, (function (param) {
                                  return false;
                                }));
                        }),
                      visible: match$2[0],
                      children: "You should have at least 2 choices"
                    }), React.createElement(ReactNativePaper.Snackbar, {
                      onDismiss: (function (param) {
                          Curry._1(setVisibleVoter, (function (param) {
                                  return false;
                                }));
                        }),
                      visible: match$1[0],
                      children: "You should have at least 1 voter"
                    })));
}

var make = ElectionNew;

export {
  make ,
}
/* react Not a pure module */
