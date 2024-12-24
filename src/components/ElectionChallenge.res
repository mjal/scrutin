@react.component
let make = (~setup: Setup.t, ~electionId, ~userToken: string) => {
  let _ = (setup, electionId, userToken)
  <></>
  /*
  let (_state, dispatch) = StateContext.use()
  let (userToken, setUserToken) = React.useState(_ => userToken)

  let submit = _ => {
    let account = Account.make()
    dispatch(StateMsg.Account_Add(account))

    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "userId", Js.Json.string(account.userId))
      Js.Dict.set(dict, "userToken", Js.Json.string(userToken))
      Js.Json.object_(dict)
    }

    X.post(`${URL.server_auth_email}/challenge`, data)
    ->Promise.then(Webapi.Fetch.Response.json)
    ->Promise.thenResolve(json => {
      let ev = Event_.from_json(json)
      dispatch(StateMsg.Event_Add_With_Broadcast(ev))
      dispatch(StateMsg.Navigate(list{"elections", electionId, "booth"}))
    })->Promise.thenResolve(Js.log)
    ->ignore
  }

  // Auto-submit
  React.useEffect0(() => {
    if userToken != "" {
      submit()
    }
    None
  })

  <>
    <ElectionHeader election />
    <S.Title> {"Invitation par token"->React.string} </S.Title>
    <S.TextInput
      testID="input-token" value=userToken onChangeText={text => setUserToken(_ => text)}
    />
    <S.Button title="Utiliser" onPress=submit />
  </>
  */
}
