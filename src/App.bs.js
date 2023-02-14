// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "./X.bs.js";
import * as Home from "./components/Home.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as State from "./state/State.bs.js";
import * as React from "react";
import * as UseTea from "rescript-use-tea/src/UseTea.bs.js";
import * as Context from "./state/Context.bs.js";
import * as Profile from "./components/Profile.bs.js";
import * as ElectionNew from "./components/ElectionNew.bs.js";
import * as ElectionShow from "./components/ElectionShow.bs.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";

function App(Props) {
  var match = UseTea.useTea(State.reducer, State.initial);
  var dispatch = match[1];
  var state = match[0];
  React.useEffect((function () {
          Curry._1(dispatch, /* Init */0);
        }), []);
  var match$1 = state.route;
  var title;
  if (typeof match$1 === "number") {
    switch (match$1) {
      case /* Home */0 :
          title = "Home";
          break;
      case /* ElectionNew */1 :
          title = "Election > Nouvelle election";
          break;
      case /* Profile */2 :
          title = "Profile";
          break;
      
    }
  } else {
    title = state.election.name !== "" ? "Election > " + state.election.name : "Election > Unamed election";
  }
  var match$2 = state.route;
  var view;
  if (typeof match$2 === "number") {
    switch (match$2) {
      case /* Home */0 :
          view = React.createElement(Home.make, {});
          break;
      case /* ElectionNew */1 :
          view = React.createElement(ElectionNew.make, {});
          break;
      case /* Profile */2 :
          view = React.createElement(Profile.make, {});
          break;
      
    }
  } else {
    view = React.createElement(ElectionShow.make, {});
  }
  return React.createElement(ReactNativePaper.Provider, {
              children: React.createElement(Context.State.Provider.make, {
                    value: state,
                    children: React.createElement(Context.Dispatch.Provider.make, {
                          value: dispatch,
                          children: React.createElement(ReactNative.SafeAreaView, {
                                style: X.styles.layout,
                                children: null
                              }, React.createElement(ReactNativePaper.Appbar.Header, {
                                    children: state.route !== /* Home */0 ? React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Appbar.BackAction, {
                                                onPress: (function (param) {
                                                    Curry._1(dispatch, {
                                                          TAG: /* Navigate */12,
                                                          _0: /* Home */0
                                                        });
                                                  })
                                              }), React.createElement(ReactNativePaper.Appbar.Content, {
                                                title: title
                                              }), React.createElement(ReactNativePaper.Appbar.Action, {
                                                icon: "account",
                                                onPress: (function (param) {
                                                    
                                                  })
                                              })) : React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Appbar.Content, {
                                                title: title,
                                                style: X.styles["pad-left"]
                                              }))
                                  }), view)
                        })
                  }),
              theme: {
                dark: true
              }
            });
}

var make = App;

export {
  make ,
}
/* X Not a pure module */
