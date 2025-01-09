@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(ElectionNewState.reducer, ElectionNewState.empty)
  //let (globalState, globalDispatch) = StateContext.use()

  switch (state.step) {
  | Step1 => <ElectionNewStep1 dispatch />
  | Step2 => <ElectionNewStep2 state dispatch />
  | Step3 => <ElectionNewStep3 />
  | Step4 => <ElectionNewStep4 state dispatch />
  | Step5 => <ElectionNewStep5 />
  }
}
