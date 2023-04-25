let use = () => {
  let (state, dispatch) = StateContext.use()

  // TODO: Refactor

  switch state.route {
  | list{"elections", electionId} =>
    switch Map.String.get(state.elections, electionId) {
    | Some(election) =>
      switch election.originId {
      | Some(originId) =>
        switch Map.String.get(state.electionLatestIds, originId) {
        | Some(electionId) => dispatch(Navigate(list{"elections", electionId}))
        | None => ()
        }
      | None => ()
      }
    | None => ()
    }
  | _ => ()
  }
}
