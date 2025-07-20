let storeLanguage = async (language, _dispatch) =>
  ReactNativeAsyncStorage.setItem("config.language", language)->ignore

let loadLanguage = async ((), _dispatch) =>
  ReactNativeAsyncStorage.getItem("config.language")
  ->Promise.thenResolve(Js.Null.toOption)
  ->Promise.thenResolve(language => {
    switch language {
    | Some(language) =>
      let {i18n} = ReactI18next.useTranslation()
      i18n.changeLanguage(. language)
    | None => ()
    }
  })
  ->ignore

let goToUrl = async dispatch => {
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.dangerouslyGetInitialUrl()
    dispatch(StateMsg.Navigate(url.path))
  }
}

type res_t = {
  success: bool,
  setup: Setup.serialized_t,
  ballots: array<Ballot.t>,
  encryptedTally: Js.null<EncryptedTally.t>,
  partialDecryptions: array<PartialDecryption.t>,
  result: Js.null<Result_.t>
}
let fetchElection = async (uuid, dispatch) => {
  let response = await Webapi.Fetch.fetch(`${Config.server_url}/${uuid}`)
  switch Webapi.Fetch.Response.ok(response) { 
  | false =>
    Js.log("Can't find election")
  | true =>
    let json = await Webapi.Fetch.Response.json(response)
    let res : res_t = Obj.magic(json)
    let {
      setup,
      ballots,
      encryptedTally,
      partialDecryptions,
      result
    } = res
    let electionData = ElectionData.parse({
      setup,
      ballots,
      encryptedTally: Js.Null.toOption(encryptedTally),
      partialDecryptions,
      result: Js.Null.toOption(result)
    })
    dispatch(StateMsg.Election_Set(uuid, electionData))
  }
}
