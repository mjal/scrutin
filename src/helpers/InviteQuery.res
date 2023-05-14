let send = (dispatch, admin, type_, username, electionId, sendInvite)  => {
  let data = {
    let dict = Js.Dict.empty()
    Js.Dict.set(dict, "username", Js.Json.string(username))
    Js.Dict.set(dict, "type", Js.Json.string(type_))
    Js.Dict.set(dict, "electionId", Js.Json.string(electionId))
    Js.Dict.set(dict, "sendInvite", Js.Json.boolean(sendInvite))
    Js.Json.object_(dict)
  }

  X.post(`${URL.server_auth_email}/users`, data)
  ->Promise.then(Webapi.Fetch.Response.json)
  ->Promise.then(json => {
    switch Js.Json.classify(json) {
    | Js.Json.JSONObject(value) =>
      let optionalManagerId = value
      ->Js.Dict.get("managerId")
      ->Option.flatMap(Js.Json.decodeString)
      Promise.resolve(optionalManagerId)
    | _ => failwith("Expected an object")
    }
  })
  ->Promise.thenResolve((optionalManagerId) => {
    switch (optionalManagerId) {
    | Some(managerId) =>
      let invitation: Invitation.t = {
        userId: managerId,
        email: Some(username),
        phoneNumber: None
      }
      dispatch(StateMsg.Invitation_Add(invitation))
      let ev = Event_.ElectionVoter.create({
        electionId,
        voterId: managerId,
      }, admin)
      dispatch(Event_Add_With_Broadcast(ev))
      dispatch(Navigate(list{"elections", electionId}))
    | None => Js.log("No managerId found...")
    }
  })->ignore
}
