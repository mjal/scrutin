@react.component
let make = (~election: Election.t, ~electionId) => {
  let (state, _dispatch) = StateContext.use()

  let ballots = Map.String.toArray(state.ballots)
  ->Array.keep(((_id, ballot)) => ballot.electionId == electionId)
  ->Array.keep(((_id, ballot)) => Option.isNone(ballot.previousId))

  <>
    <ElectionHeader election section=#inviteManage />

    { Array.map(ballots, ((id, ballot)) => {
      <List.Item title=ballot.voterPublicKey key=id />
    }) -> React.array }
  </>
}

