// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Candidate from "./Candidate.bs.js";
import * as Core from "@material-ui/core";

function CandidateList(Props) {
  var dispatch = Props.dispatch;
  var state = Props.state;
  var match = React.useState(function () {
        return "";
      });
  var setFirstName = match[1];
  var firstName = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setLastName = match$1[1];
  var lastName = match$1[0];
  var onChangeFirstName = function ($$event) {
    Curry._1(setFirstName, $$event.currentTarget.value);
  };
  var onChangeLastName = function ($$event) {
    Curry._1(setLastName, $$event.currentTarget.value);
  };
  var onClick = function (e) {
    Curry._1(dispatch, {
          TAG: /* AddCandidate */3,
          _0: lastName + " " + firstName
        });
    Curry._1(setFirstName, (function (param) {
            return "";
          }));
    Curry._1(setLastName, (function (param) {
            return "";
          }));
  };
  return React.createElement("div", undefined, React.createElement("h2", undefined, "Candidats"), state.candidates.map(function (name) {
                  return React.createElement(Candidate.make, {
                              name: name,
                              dispatch: dispatch,
                              key: name
                            });
                }), React.createElement(Core.Box, {
                  children: null
                }, React.createElement(Core.TextField, {
                      label: "Prénom",
                      onChange: onChangeFirstName,
                      value: firstName,
                      variant: "outlined"
                    }), React.createElement(Core.TextField, {
                      label: "Nom",
                      onChange: onChangeLastName,
                      value: lastName,
                      variant: "outlined"
                    }), React.createElement(Core.Button, {
                      onClick: onClick,
                      children: "Ajouter",
                      size: "large",
                      variant: "contained"
                    })));
}

var make = CandidateList;

export {
  make ,
}
/* react Not a pure module */
