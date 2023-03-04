// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "./state/State.bs.js";
import * as React from "react";
import * as UseTea from "rescript-use-tea/src/UseTea.bs.js";
import * as ReactNativePaper from "react-native-paper";

function Header(Props) {
  var match = UseTea.useTea(State.reducer, State.initial);
  var dispatch = match[1];
  return React.createElement(ReactNativePaper.Appbar.Header, {
              children: null
            }, React.createElement(ReactNativePaper.Appbar.Action, {
                  icon: "home",
                  onPress: (function (param) {
                      Curry._1(dispatch, {
                            TAG: /* Navigate */0,
                            _0: /* Home_Elections */0
                          });
                    })
                }), React.createElement(ReactNativePaper.Appbar.Content, {
                  title: "Verifiable secret voting"
                }));
}

var make = Header;

export {
  make ,
}
/* State Not a pure module */
