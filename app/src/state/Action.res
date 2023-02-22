type t =
  | Init
  | Election_PublishResult(string)
  | Election_SetResult(option<string>)
  | Election_SetName(string)
  //| Election_SetBelenios(option<string>, option<string>, option<string>)
  | Election_AddVoter(string)
  | Election_RemoveVoter(int)
  | Election_AddChoice(string)
  | Election_RemoveChoice(int)
  | Election_Fetch(string)
  | Election_Load(Js.Json.t)
  | Election_LoadAll(array<Js.Json.t>)
  | Election_Post
  | Election_Tally(Belenios.Trustees.Privkey.t)
  | Ballot_Create_Start(string, array<int>)
  | Ballot_Create_End
  | Navigate(Route.t)
  | User_Login(User.t)
  | User_Logout
  | Trustees_Set(array<Trustee.t>)
  | Tokens_Set(array<Token.t>)

  | Member_Register(string) // email
  | Member_Register_Confirm(string, Sjcl.Ecdsa.PublicKey.t) // token, publicKey