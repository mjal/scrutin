module Item = {
  @react.component
  let make = (~userId) => {
    let (state, _dispatch) = StateContext.use()

    let invitation = state->State.getInvitationExn(userId)
    let email = Option.getWithDefault(invitation.email, "No email")

    <List.Item title=userId description=email />
  }
}

@react.component
let make = (~election: Election.t) => {
  <>
    <ElectionHeader election section=#inviteManage />

    { Array.map(election.voterIds, (userId) =>
      <Item key=userId userId />
    ) -> React.array }
  </>
}
