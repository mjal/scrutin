@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(Election_New_State.reducer, Election_New_State.empty)

  switch (state.step) {
  | Step1 => <Election_New_Step1 dispatch />
  | Step2 => <Election_New_Step2 state dispatch />
  | Step3 => <Election_New_Step3 state dispatch />
  | Step4 => <Election_New_Step4 state dispatch />
  | Step5 => <Election_New_Step5 state dispatch />
  }
}
