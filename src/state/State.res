type t = {
  route: list<string>,
  electionDatas: Map.String.t<ElectionData.t>,

  electionsTryFetch: Map.String.t<bool>,

  fetchingEvents: bool,
  accounts: array<Account.t>,
  trustees: array<Trustee.t>,
  invitations: array<Invitation.t>,
  electionLatestIds: Map.String.t<string>,
}

// The initial state of the application
let initial = {
  route: list{""},
  //events: [],
  fetchingEvents: true,
  accounts: [],
  trustees: [],
  invitations: [],
  electionDatas: Map.String.empty,
  electionLatestIds: Map.String.empty,
  electionsTryFetch: Map.String.empty,
}

//let getBallot = (state, id) => Map.String.get(state.ballots, id)
//let getBallotExn = (state, id) => Map.String.getExn(state.ballots, id)

let getAccount = (state, publicKey) => Array.getBy(state.accounts, id => publicKey == id.userId)
let getAccountExn = (state, publicKey) => getAccount(state, publicKey)->Option.getExn

let getInvitation = (state, userId) => Array.getBy(state.invitations, invitation => userId == invitation.userId)
let getInvitationExn = (state, userId) => getInvitation(state, userId)->Option.getExn

//let getElectionValidBallots = (state, electionId) => {
//  state.ballots
//  ->Array.keep((ballot) => ballot.electionId == electionId)
//  ->Js.Array2.map((ballot) => (ballot.voterId, ballot))
//  ->Js.Dict.fromArray
//  ->Js.Dict.values
//}

//let getElectionAdmin = (state, election:Election.t) =>
//  Array.getBy(state.accounts, (account) => {
//    Array.getBy(election.adminIds, (userId) => userId == account.userId)
//    ->Option.isSome
//  })

//let getElectionAdminExn = (state, election:Election.t) =>
//  getElectionAdmin(state, election)->Option.getExn
