// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_array from "rescript/lib/es6/js_array.js";

var initialState_voters = [];

var initialState_candidates = [];

var initialState = {
  electionName: "Élection sans nom",
  voters: initialState_voters,
  candidates: initialState_candidates
};

function reducer(state, action) {
  switch (action.TAG | 0) {
    case /* SetElectionName */0 :
        return {
                electionName: action._0,
                voters: state.voters,
                candidates: state.candidates
              };
    case /* AddVoter */1 :
        return {
                electionName: state.electionName,
                voters: Js_array.concat(state.voters, [action._0]),
                candidates: state.candidates
              };
    case /* RemoveVoter */2 :
        var name = action._0;
        return {
                electionName: state.electionName,
                voters: state.voters.filter(function (voterName) {
                      return voterName !== name;
                    }),
                candidates: state.candidates
              };
    case /* AddCandidate */3 :
        return {
                electionName: state.electionName,
                voters: state.voters,
                candidates: Js_array.concat(state.candidates, [action._0])
              };
    case /* RemoveCandidate */4 :
        var name$1 = action._0;
        return {
                electionName: state.electionName,
                voters: state.candidates.filter(function (candidateName) {
                      return name$1 !== candidateName;
                    }),
                candidates: state.candidates
              };
    
  }
}

export {
  initialState ,
  reducer ,
}
/* No side effect */
