@react.component
let make = (~election:Election.t, ~electionId) => {
  <>
    <ElectionHeader election />
    <ElectionResultChart electionId />
  </>
}

