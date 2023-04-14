@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()

  switch State.getElection(state, electionId) {
  | None => <NotFound />
  | Some(election) =>
    switch election.result {
    | None => <Election_Show_InProgress electionId election />
    | Some(_result) =>
      <ElectionResult electionId election />
    }
  }
}
