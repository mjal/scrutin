type t

@module("sirona") @scope("Ballot") @val
external generate : (Setup.t, string, array<array<int>>) => t = "generate"

external toJSON : t => Js.Json.t = "%identity"

//let make = (~election: Election.t, ~electionId, ~voterId, ~selection: array<int>) => {
//  let trustees = Belenios.Trustees.of_str(election.trustees)
//  let params = Belenios.Election.parse(election.params)
//  let (pubcreds, privcreds) = Belenios.Credentials.create(params.uuid, 1)
//  let (pubcred, privcred) = (Array.getExn(pubcreds, 0), Array.getExn(privcreds, 0))
//
//  let ciphertext =
//    Belenios.Election.vote(
//      params,
//      ~cred=privcred,
//      ~selections=[selection],
//      ~trustees,
//    )->Belenios.Ballot.to_str
//
//  {
//    electionId,
//    voterId,
//    ciphertext,
//    pubcred
//  }
//}
