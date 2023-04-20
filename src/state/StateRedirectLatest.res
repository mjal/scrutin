let use = () => {
  let (state, dispatch) = StateContext.use()

  switch state.route {
  | list{"elections", electionId} =>
    switch Map.String.get(state.electionReplacementIds, electionId) {
    | Some(replacementId) => dispatch(Navigate(list{"elections", replacementId}))
    | None => ()
    }
  | list{"ballots", ballotId} =>
    switch Map.String.get(state.ballotReplacementIds, ballotId) {
    | Some(replacementId) => dispatch(Navigate(list{"ballots", replacementId}))
    | None => ()
    }
  | _ => ()
  }
}
