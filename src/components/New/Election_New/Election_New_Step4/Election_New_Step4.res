@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  switch state.access {
  | Some(#"open") => <Election_New_Step4_Open state setState />
  | Some(#closed) => <Election_New_Step4_Closed state setState />
  | _ => Js.Exn.raiseError("Error: access is not set")
  }
}
