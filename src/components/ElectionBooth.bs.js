// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../state/Context.bs.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";
import * as ElectionBooth_ChoiceSelect from "./ElectionBooth_ChoiceSelect.bs.js";

function ElectionBooth(Props) {
  var match = Context.use(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setToken = match$1[1];
  var token = match$1[0];
  var match$2 = React.useState(function () {
        return /* Blank */0;
      });
  var setChoice = match$2[1];
  var choice = match$2[0];
  React.useEffect((function () {
          var token = Js_string.sliceToEnd(1, window.location.hash);
          Curry._1(setToken, (function (param) {
                  return token;
                }));
        }), []);
  var vote = function (param) {
    var selectionArray = Belt_Array.mapWithIndex(Belt_Array.make(state.election.choices.length, 0), (function (i, param) {
            if (Caml_obj.equal(choice, /* Choice */{
                    _0: i
                  })) {
              return 1;
            } else {
              return 0;
            }
          }));
    Curry._1(dispatch, {
          TAG: /* Ballot_Create */10,
          _0: token,
          _1: selectionArray
        });
  };
  return React.createElement(ReactNative.View, {
              children: null
            }, React.createElement(ReactNativePaper.Title, {
                  style: X.styles.title,
                  children: state.election.name
                }), React.createElement(ReactNative.View, {
                  style: X.styles.separator
                }), React.createElement(ElectionBooth_ChoiceSelect.make, {
                  currentChoice: choice,
                  onChoiceChange: (function (choice) {
                      Curry._1(setChoice, (function (param) {
                              return choice;
                            }));
                    })
                }), React.createElement(ReactNativePaper.TextInput, {
                  mode: "flat",
                  label: "Token",
                  value: token,
                  onChangeText: (function (text) {
                      Curry._1(setToken, (function (param) {
                              return text.trim();
                            }));
                    })
                }), React.createElement(X.Row.make, {
                  children: null
                }, React.createElement(X.Col.make, {
                      children: React.createElement(ReactNativePaper.Button, {
                            onPress: vote,
                            children: "Vote"
                          })
                    }), React.createElement(X.Col.make, {
                      children: React.createElement(ReactNativePaper.Button, {
                            onPress: (function (param) {
                                Curry._1(dispatch, {
                                      TAG: /* Navigate */11,
                                      _0: {
                                        TAG: /* ElectionShow */0,
                                        _0: state.election.id
                                      }
                                    });
                              }),
                            children: "Admin"
                          })
                    })));
}

var make = ElectionBooth;

export {
  make ,
}
/* X Not a pure module */
