@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Election_New_State.empty)

  switch (state.step) {
  | Step1 => <Election_New_Step1 state setState />
  | Step2 => <Election_New_Step2 state setState />
  | Step3 => <Election_New_Step3 state setState />
  | Step4 => <Election_New_Step4 state setState />
  | Step5 => <Election_New_Step5 state setState />
  }
}
