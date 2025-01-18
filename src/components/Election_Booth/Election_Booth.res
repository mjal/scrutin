@react.component
let make = (~electionData: ElectionData.t) => {
  let (state, setState) = React.useState(_ => Election_Booth_State.empty)

  switch (state.step) {
  | Step1 => <Election_Booth_Step1 electionData state setState />
  | Step2 => <Election_Booth_Step2 electionData state setState />
  | Step3 => <Election_Booth_Step3 electionData state setState />
  | Step4 => <Election_Booth_Step4 electionData state setState />
  }
}
