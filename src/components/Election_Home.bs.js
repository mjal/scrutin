// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../helpers/X.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../helpers/Context.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as ReactNativePaper from "react-native-paper";

function Election_Home$Election(Props) {
  var id = Props.id;
  var election = Props.election;
  var match = Context.use(undefined);
  var dispatch = match[1];
  var electionParams = JSON.parse(election.params);
  var show = function (param) {
    Curry._1(dispatch, {
          TAG: /* Navigate */0,
          _0: {
            TAG: /* Election_Show */0,
            _0: id
          }
        });
  };
  return React.createElement(ReactNativePaper.Card, {
              children: null
            }, React.createElement(ReactNativePaper.Card.Content, {
                  children: React.createElement(ReactNativePaper.List.Section, {
                        title: "Election en cours",
                        children: null
                      }, React.createElement(ReactNativePaper.List.Item, {
                            title: "Name",
                            description: electionParams.name
                          }), React.createElement(ReactNativePaper.List.Item, {
                            title: "Description",
                            description: electionParams.description
                          }))
                }), React.createElement(ReactNativePaper.Card.Actions, {
                  children: React.createElement(ReactNativePaper.Button, {
                        mode: "contained",
                        onPress: show,
                        children: "Go"
                      })
                }));
}

var Election = {
  make: Election_Home$Election
};

function Election_Home(Props) {
  var match = Context.use(undefined);
  var dispatch = match[1];
  return React.createElement(React.Fragment, undefined, React.createElement(X.Title.make, {
                  children: "-"
                }), React.createElement(ReactNativePaper.Button, {
                  mode: "contained",
                  onPress: (function (param) {
                      Curry._1(dispatch, {
                            TAG: /* Navigate */0,
                            _0: /* Election_New */5
                          });
                    }),
                  children: "Creer une nouvelle election"
                }), React.createElement(X.Title.make, {
                  children: "-"
                }), Belt_Array.map(Belt_MapString.toArray(match[0].cached_elections), (function (param) {
                    var id = param[0];
                    return React.createElement(Election_Home$Election, {
                                id: id,
                                election: param[1],
                                key: id
                              });
                  })), React.createElement(X.Title.make, {
                  children: "-"
                }));
}

var make = Election_Home;

export {
  Election ,
  make ,
}
/* X Not a pure module */
