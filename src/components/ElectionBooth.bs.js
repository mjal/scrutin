// Generated by ReScript, PLEASE EDIT WITH CARE

import * as X from "../X.bs.js";
import * as $$URL from "../helpers/URL.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Store from "../state/Store.bs.js";
import * as React from "react";
import * as Context from "../state/Context.bs.js";
import * as Belenios from "../Belenios.bs.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactNative from "react-native";
import * as ReactNativePaper from "react-native-paper";
import * as ElectionBooth_ChoiceSelect from "./ElectionBooth_ChoiceSelect.bs.js";

function ElectionBooth(Props) {
  var match = Context.use(undefined);
  var dispatch = match[1];
  var state = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setPrivateCred = match$1[1];
  var privateCred = match$1[0];
  var match$2 = React.useState(function () {
        
      });
  var setTmpToken = match$2[1];
  var tmpToken = match$2[0];
  var match$3 = React.useState(function () {
        return /* Blank */0;
      });
  var setChoice = match$3[1];
  var choice = match$3[0];
  var match$4 = React.useState(function () {
        return false;
      });
  var setshowModal = match$4[1];
  var match$5 = React.useState(function () {
        return false;
      });
  var setVisibleError = match$5[1];
  var match$6 = React.useState(function () {
        return false;
      });
  var setHasVoted = match$6[1];
  var match$7 = React.useState(function () {
        return false;
      });
  var setChangeVote = match$7[1];
  var electionPublicCreds = Belt_Option.getWithDefault(Belt_Option.map(state.election.creds, (function (prim) {
              return JSON.parse(prim);
            })), []);
  var isValidPrivateCred = function (token) {
    return Belt_Array.some(electionPublicCreds, (function (electionPublicCred) {
                  return electionPublicCred === token.public;
                }));
  };
  var addToken = function (param) {
    if (tmpToken === undefined) {
      return ;
    }
    try {
      var token_public = Belenios.Credentials.derive(Belt_Option.getExn(state.election.uuid), tmpToken);
      var token = {
        public: token_public,
        private_: tmpToken
      };
      if (isValidPrivateCred(token)) {
        Curry._1(setPrivateCred, (function (param) {
                return tmpToken;
              }));
        return Curry._1(setshowModal, (function (param) {
                      return false;
                    }));
      } else {
        return Curry._1(setVisibleError, (function (param) {
                      return true;
                    }));
      }
    }
    catch (exn){
      return Curry._1(setVisibleError, (function (param) {
                    return true;
                  }));
    }
  };
  React.useEffect(function () {
        var storedToken = Belt_Array.getBy(state.tokens, isValidPrivateCred);
        if (storedToken !== undefined && Belt_Option.isNone(privateCred)) {
          Curry._1(setPrivateCred, (function (param) {
                  return storedToken.private_;
                }));
        }
        console.log("privateCred");
        console.log(privateCred);
        console.log($$URL.currentHash(undefined));
        var hash = Js_string.sliceToEnd(1, $$URL.currentHash(undefined));
        if (hash !== "") {
          var uuid = state.election.uuid;
          if (uuid !== undefined) {
            var publicCred = Belenios.Credentials.derive(uuid, hash);
            Store.Token.add({
                  public: publicCred,
                  private_: hash
                });
            if (Belt_Option.isNone(privateCred)) {
              Curry._1(setPrivateCred, (function (param) {
                      return hash;
                    }));
            }
            
          }
          
        }
        
      });
  React.useEffect(function () {
        if (privateCred !== undefined) {
          var publicCred = Belenios.Credentials.derive(Belt_Option.getExn(state.election.uuid), privateCred);
          if (Belt_Array.some(state.election.ballots, (function (b) {
                    return b.public_credential === publicCred ? Belt_Option.getWithDefault(b.ciphertext, "") !== "" : false;
                  }))) {
            Curry._1(setHasVoted, (function (param) {
                    return true;
                  }));
          }
          
        }
        
      });
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
          TAG: /* Ballot_Create_Start */11,
          _0: Belt_Option.getExn(privateCred),
          _1: selectionArray
        });
    Curry._1(setHasVoted, (function (param) {
            return true;
          }));
    Curry._1(setChangeVote, (function (param) {
            return false;
          }));
  };
  return React.createElement(React.Fragment, undefined, state.voting_in_progress ? React.createElement(ReactNativePaper.Title, {
                    style: X.styles.title,
                    children: null
                  }, React.createElement(ReactNativePaper.Text, {
                        children: "Voting in progress..."
                      }), React.createElement(ReactNativePaper.ActivityIndicator, {})) : React.createElement(React.Fragment, undefined, React.createElement(ReactNative.View, {
                        style: X.styles.separator
                      }), match$6[0] && !match$7[0] ? React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Title, {
                              style: ReactNative.StyleSheet.flatten([
                                    X.styles.title,
                                    X.styles.green
                                  ]),
                              children: "Vous avez voté"
                            }), React.createElement(ReactNativePaper.Button, {
                              mode: "contained",
                              onPress: (function (param) {
                                  Curry._1(setChangeVote, (function (param) {
                                          return true;
                                        }));
                                }),
                              children: "Changer mon vote"
                            })) : React.createElement(React.Fragment, undefined, Belt_Option.isSome(privateCred) ? React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Title, {
                                    style: ReactNative.StyleSheet.flatten([
                                          X.styles.title,
                                          X.styles.green
                                        ]),
                                    children: "Vous avez un droit de vote pour cette election"
                                  }), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ElectionBooth_ChoiceSelect.make, {
                                    currentChoice: choice,
                                    onChoiceChange: (function (choice) {
                                        Curry._1(setChoice, (function (param) {
                                                return choice;
                                              }));
                                      })
                                  }), React.createElement(ReactNativePaper.Divider, {}), React.createElement(ReactNativePaper.Button, {
                                    mode: "contained",
                                    onPress: vote,
                                    children: "Voter"
                                  })) : React.createElement(React.Fragment, undefined, React.createElement(ReactNativePaper.Title, {
                                    style: ReactNative.StyleSheet.flatten([
                                          X.styles.title,
                                          X.styles.red
                                        ]),
                                    children: "Vous n'avez pas de droit de vote pour cette election"
                                  }), React.createElement(ReactNativePaper.Button, {
                                    mode: "contained",
                                    onPress: (function (param) {
                                        Curry._1(setshowModal, (function (param) {
                                                return true;
                                              }));
                                      }),
                                    children: "Ajouter un droit de vote"
                                  })))), React.createElement(ReactNativePaper.Portal, {
                  children: null
                }, React.createElement(ReactNativePaper.Modal, {
                      visible: match$4[0],
                      onDismiss: (function (param) {
                          Curry._1(setshowModal, (function (param) {
                                  return false;
                                }));
                        }),
                      children: React.createElement(ReactNative.View, {
                            style: ReactNative.StyleSheet.flatten([
                                  X.styles.modal,
                                  X.styles.layout
                                ]),
                            children: null
                          }, React.createElement(ReactNativePaper.TextInput, {
                                mode: "flat",
                                autoFocus: true,
                                label: "Token",
                                value: Belt_Option.getWithDefault(tmpToken, ""),
                                onChangeText: (function (text) {
                                    Curry._1(setTmpToken, (function (param) {
                                            return text.trim();
                                          }));
                                  })
                              }), React.createElement(X.Row.make, {
                                children: null
                              }, React.createElement(X.Col.make, {
                                    children: React.createElement(ReactNativePaper.Button, {
                                          onPress: (function (param) {
                                              Curry._1(setTmpToken, (function (param) {
                                                      
                                                    }));
                                              Curry._1(setshowModal, (function (param) {
                                                      return false;
                                                    }));
                                            }),
                                          children: "Retour"
                                        })
                                  }), React.createElement(X.Col.make, {
                                    children: React.createElement(ReactNativePaper.Button, {
                                          mode: "contained",
                                          onPress: addToken,
                                          children: "Ajouter"
                                        })
                                  })))
                    }), React.createElement(ReactNativePaper.Snackbar, {
                      onDismiss: (function (param) {
                          Curry._1(setVisibleError, (function (param) {
                                  return false;
                                }));
                        }),
                      visible: match$5[0],
                      children: "Invalid token"
                    })));
}

var make = ElectionBooth;

export {
  make ,
}
/* X Not a pure module */
