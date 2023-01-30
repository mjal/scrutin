// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "../state/State.bs.js";
import * as React from "react";
import * as ReactNative from "react-native";
import * as Home_ElectionList from "./Home_ElectionList.bs.js";
import * as ReactNativePaper from "react-native-paper";

function Home(Props) {
  var match = State.useContextReducer(undefined);
  var dispatch = match[1];
  ReactNativePaper.useTheme();
  return React.createElement(ReactNative.View, {
              children: null
            }, React.createElement(ReactNative.View, {
                  style: X.styles.separator
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "contained",
                  style: X.styles["margin-x"],
                  onPress: (function (param) {
                      Curry._1(dispatch, {
                            TAG: /* Navigate */10,
                            _0: /* ElectionNew */1
                          });
                    }),
                  children: "Creer une nouvelle election"
                }), React.createElement(ReactNative.View, {
                  style: X.styles.separator
                }), React.createElement(Home_ElectionList.make, {}));
}

var make = Home;

export {
  make ,
}
/* X Not a pure module */