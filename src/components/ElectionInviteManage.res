module Item = {
  @react.component
  let make = (~ballotId, ~ballot: Ballot.t) => {
    let (state, _dispatch) = StateContext.use()

    let _ = ballotId
    let invitation = state->State.getInvitationExn(ballot.voterPublicKey)
    let email = Option.getWithDefault(invitation.email, "No email")

    <List.Item title=ballot.voterPublicKey description=email />
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, _dispatch) = StateContext.use()

  let ballots = Map.String.toArray(state.ballots)
  ->Array.keep(((_id, ballot)) => ballot.electionId == electionId)
  ->Array.keep(((_id, ballot)) => Option.isNone(ballot.previousId))

  <>
    <ElectionHeader election section=#inviteManage />

    { Array.map(ballots, ((ballotId, ballot)) =>
      <Item key=ballotId ballotId ballot />
    ) -> React.array }
  </>
}
