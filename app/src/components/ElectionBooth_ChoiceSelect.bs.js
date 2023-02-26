// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Context from "../state/Context.bs.js";
import * as Belenios from "../helpers/Belenios.bs.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";

var styles = ReactNative.StyleSheet.create({
      "margin-x": {
        marginLeft: 15.0,
        marginRight: 15.0
      }
    });

function ElectionBooth_ChoiceSelect$Choice(Props) {
  var name = Props.name;
  var selected = Props.selected;
  var onSelect = Props.onSelect;
  return React.createElement(ReactNativePaper.List.Item, {
              onPress: (function (param) {
                  Curry._1(onSelect, undefined);
                }),
              title: name,
              left: (function (param) {
                  return React.createElement(ReactNativePaper.List.Icon, {
                              icon: selected ? "checkbox-intermediate" : "checkbox-blank-outline"
                            });
                })
            });
}

var Choice = {
  make: ElectionBooth_ChoiceSelect$Choice
};

function ElectionBooth_ChoiceSelect(Props) {
  var currentChoice = Props.currentChoice;
  var onChoiceChange = Props.onChoiceChange;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var match = Context.use(undefined);
  var params = match[0].election.params;
  return React.createElement(ReactNative.View, {
              children: React.createElement(ReactNativePaper.List.Section, {
                    title: disabled ? "Liste des choix" : "Faites votre choix",
                    children: params !== undefined ? Belt_Array.mapWithIndex(Belenios.Election.answers(params), (function (i, choiceName) {
                              var selected = Caml_obj.equal(currentChoice, /* Choice */{
                                    _0: i
                                  });
                              if (disabled) {
                                return React.createElement(ReactNativePaper.List.Item, {
                                            title: choiceName
                                          });
                              } else {
                                return React.createElement(ElectionBooth_ChoiceSelect$Choice, {
                                            name: choiceName,
                                            selected: selected,
                                            onSelect: (function (param) {
                                                Curry._1(onChoiceChange, /* Choice */{
                                                      _0: i
                                                    });
                                              }),
                                            key: String(i)
                                          });
                              }
                            })) : React.createElement(React.Fragment, undefined),
                    style: styles["margin-x"]
                  })
            });
}

var make = ElectionBooth_ChoiceSelect;

export {
  styles ,
  Choice ,
  make ,
}
/* styles Not a pure module */
