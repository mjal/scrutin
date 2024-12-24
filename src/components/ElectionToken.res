@react.component
let make = (~setup: Setup.t, ~electionId, ~secret: string) => {
  let (_state, dispatch) = StateContext.use()
  let election = setup.election
  //let (userToken, setUserToken) = React.useState(_ => userToken)

  let account = Account.make2(~secret)

  Js.log("Adding account")
  Js.log(account)

  dispatch(StateMsg.Account_Add(account))
  dispatch(StateMsg.Navigate(list{"elections", electionId, "booth"}))

  <>
    <ElectionHeader election />
    <S.Title> {"Invitation par token. Please wait redirect."->React.string} </S.Title>
  </>
}
