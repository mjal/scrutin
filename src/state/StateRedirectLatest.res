let use = () => {
  let (state, dispatch) = Context.use()

  switch state.route {
  | list{"elections", electionId} =>
    switch Map.String.get(state.cachedElectionReplacementIds, electionId) {
    | Some(replacementId) =>
      dispatch(Navigate(list{"elections", replacementId}))
    | None => ()
    }
  | list{"ballots", ballotId} =>
    switch Map.String.get(state.cachedBallotReplacementIds, ballotId) {
    | Some(replacementId) =>
      dispatch(Navigate(list{"ballots", replacementId}))
    | None => ()
    }
  | _ => ()
  }
}
