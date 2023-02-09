// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as AsyncStorage from "@react-native-async-storage/async-storage";

var keyName = "user";

function get(param) {
  return AsyncStorage.default.getItem(keyName).then(function (prim) {
                if (prim === null) {
                  return ;
                } else {
                  return Caml_option.some(prim);
                }
              }).then(function (oo) {
              if (oo !== undefined) {
                return JSON.parse(oo);
              }
              
            });
}

function set(o) {
  AsyncStorage.default.setItem(keyName, JSON.stringify(o));
}

function clean(param) {
  AsyncStorage.default.removeItem(keyName);
}

var User = {
  keyName: keyName,
  get: get,
  set: set,
  clean: clean
};

var keyName$1 = "trusteesKeys";

function get$1(param) {
  return AsyncStorage.default.getItem(keyName$1).then(function (prim) {
                if (prim === null) {
                  return ;
                } else {
                  return Caml_option.some(prim);
                }
              }).then(function (os) {
              if (os !== undefined) {
                return JSON.parse(os);
              } else {
                return [];
              }
            });
}

function set$1(a) {
  return AsyncStorage.default.setItem(keyName$1, JSON.stringify(a));
}

function add(o) {
  get$1(undefined).then(function (a) {
        var a$1 = Belt_Array.concat(a, [o]);
        return AsyncStorage.default.setItem(keyName$1, JSON.stringify(a$1));
      });
}

function clean$1(param) {
  AsyncStorage.default.removeItem(keyName$1);
}

var Trustee = {
  keyName: keyName$1,
  get: get$1,
  set: set$1,
  add: add,
  clean: clean$1
};

var keyName$2 = "tokens";

function get$2(param) {
  return AsyncStorage.default.getItem(keyName$2).then(function (prim) {
                if (prim === null) {
                  return ;
                } else {
                  return Caml_option.some(prim);
                }
              }).then(function (os) {
              if (os !== undefined) {
                return JSON.parse(os);
              } else {
                return [];
              }
            });
}

function set$2(a) {
  return AsyncStorage.default.setItem(keyName$2, JSON.stringify(a));
}

function add$1(o) {
  get$2(undefined).then(function (a) {
        var a$1 = Belt_Array.concat(a, [o]);
        return AsyncStorage.default.setItem(keyName$2, JSON.stringify(a$1));
      });
}

function clean$2(param) {
  AsyncStorage.default.removeItem(keyName$2);
}

var Token = {
  keyName: keyName$2,
  get: get$2,
  set: set$2,
  add: add$1,
  clean: clean$2
};

export {
  User ,
  Trustee ,
  Token ,
}
/* @react-native-async-storage/async-storage Not a pure module */