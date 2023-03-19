// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as StateEffect from "./StateEffect.bs.js";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";

var initial_txs = [];

var initial_ids = [];

var initial_trustees = [];

var initial_contacts = [];

var initial = {
  txs: initial_txs,
  ids: initial_ids,
  trustees: initial_trustees,
  contacts: initial_contacts,
  route: /* Home_Elections */0,
  cached_elections: undefined,
  cached_ballots: undefined
};

function reducer(state, action) {
  if (typeof action === "number") {
    return [
            initial,
            [
              StateEffect.identities_fetch,
              StateEffect.transactions_fetch,
              StateEffect.trustees_fetch,
              StateEffect.goToUrl,
              StateEffect.importIdentityFromUrl
            ]
          ];
  }
  switch (action.TAG | 0) {
    case /* Navigate */0 :
        return [
                {
                  txs: state.txs,
                  ids: state.ids,
                  trustees: state.trustees,
                  contacts: state.contacts,
                  route: action._0,
                  cached_elections: state.cached_elections,
                  cached_ballots: state.cached_ballots
                },
                []
              ];
    case /* Identity_Add */1 :
        var ids = Belt_Array.concat(state.ids, [action._0]);
        return [
                {
                  txs: state.txs,
                  ids: ids,
                  trustees: state.trustees,
                  contacts: state.contacts,
                  route: state.route,
                  cached_elections: state.cached_elections,
                  cached_ballots: state.cached_ballots
                },
                [(function (param) {
                      return StateEffect.identities_store(ids, param);
                    })]
              ];
    case /* Transaction_Add */2 :
        var tx = action._0;
        var txs = Belt_Array.concat(state.txs, [tx]);
        return [
                {
                  txs: txs,
                  ids: state.ids,
                  trustees: state.trustees,
                  contacts: state.contacts,
                  route: state.route,
                  cached_elections: state.cached_elections,
                  cached_ballots: state.cached_ballots
                },
                [
                  (function (param) {
                      return StateEffect.transactions_store(txs, param);
                    }),
                  (function (param) {
                      return StateEffect.cache_update(tx, param);
                    })
                ]
              ];
    case /* Trustee_Add */3 :
        var trustees = Belt_Array.concat(state.trustees, [action._0]);
        return [
                {
                  txs: state.txs,
                  ids: state.ids,
                  trustees: trustees,
                  contacts: state.contacts,
                  route: state.route,
                  cached_elections: state.cached_elections,
                  cached_ballots: state.cached_ballots
                },
                [(function (param) {
                      return StateEffect.trustees_store(trustees, param);
                    })]
              ];
    case /* Contact_Add */4 :
        var contacts = Belt_Array.concat(state.contacts, [action._0]);
        return [
                {
                  txs: state.txs,
                  ids: state.ids,
                  trustees: state.trustees,
                  contacts: contacts,
                  route: state.route,
                  cached_elections: state.cached_elections,
                  cached_ballots: state.cached_ballots
                },
                [(function (param) {
                      return StateEffect.contacts_store(contacts, param);
                    })]
              ];
    case /* Cache_Election_Add */5 :
        var cached_elections = Belt_MapString.set(state.cached_elections, action._0, action._1);
        return [
                {
                  txs: state.txs,
                  ids: state.ids,
                  trustees: state.trustees,
                  contacts: state.contacts,
                  route: state.route,
                  cached_elections: cached_elections,
                  cached_ballots: state.cached_ballots
                },
                []
              ];
    case /* Cache_Ballot_Add */6 :
        var cached_ballots = Belt_MapString.set(state.cached_ballots, action._0, action._1);
        return [
                {
                  txs: state.txs,
                  ids: state.ids,
                  trustees: state.trustees,
                  contacts: state.contacts,
                  route: state.route,
                  cached_elections: state.cached_elections,
                  cached_ballots: cached_ballots
                },
                []
              ];
    
  }
}

export {
  initial ,
  reducer ,
}
/* StateEffect Not a pure module */
