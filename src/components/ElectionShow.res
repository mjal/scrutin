@react.component
let make = (~election:Election.t, ~electionId) => {
  switch election.result {
  | None => <ElectionShowInProgress electionId election />
  | Some(_result) => <ElectionResult electionId election />
  }
}
