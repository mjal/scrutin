@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()

  switch State.getElection(state, electionId) {
  | None => <NotFound />
  | Some(election) =>
    switch election.result {
    | None => <ElectionShowInProgress electionId election />
    | Some(_result) =>
      <ElectionResult electionId election />
    }
  }
}
