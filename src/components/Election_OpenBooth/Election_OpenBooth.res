@react.component
let make = (~electionData: ElectionData.t) => {
  let (state, dispatch) = React.useReducer(Election_OpenBooth_State.reducer, Election_OpenBooth_State.empty)

  switch (state.step) {
  | Step1 => <Election_OpenBooth_Step1 electionData state dispatch />
  | Step2 => <Election_OpenBooth_Step2 electionData state dispatch />
  | Step3 => <Election_OpenBooth_Step3 electionData state dispatch />
  | Step4 => <Election_OpenBooth_Step4 electionData state dispatch />
  | Step5 => <Election_OpenBooth_Step5 electionData state dispatch />
  }
}

//let getSecret = () => {
//  if ReactNative.Platform.os == #web {
//    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
//    if String.length(url.hash) > 12 {
//      Some(url.hash)
//    } else {
//      None
//    }
//  } else {
//    None
//  }
//}
