let use = () => {
  let (state, dispatch) = StateContext.use()

  switch state.route {
  | list{"elections", electionId} =>
    switch Map.String.get(state.electionNextIds, electionId) {
    | Some(replacementId) => dispatch(Navigate(list{"elections", replacementId}))
    | None => ()
    }
  | list{"ballots", ballotId} =>
    switch Map.String.get(state.ballotNextIds, ballotId) {
    | Some(replacementId) => dispatch(Navigate(list{"ballots", replacementId}))
    | None => ()
    }
  | _ => ()
  }
}
