let relay_url = `${Config.api_url}/proxy_email`

let send = (ballotId, orgId: Identity.t, voterId: Identity.t, email) => {
  let hexSecretKey = Option.getExn(voterId.hexSecretKey)

  let timestamp : int = %raw(`Date.now()`)
  let hexTimestamp = Js.Int.toStringWithRadix(timestamp, ~radix=16)
  let hexSignedTimestamp = Identity.signHex(orgId, hexTimestamp)

  let message = `
    Hello !
    Vous êtes invité à une election.
    Cliquez ici pour voter :
    https://demo.scrutin.app/ballots/${ballotId}#${hexSecretKey}
  `

  let data = {
    let dict = Js.Dict.empty()
    Js.Dict.set(dict, "email", Js.Json.string(email))
    Js.Dict.set(dict, "subject",
      Js.Json.string("Vous êtes invité à un election"))
    Js.Dict.set(dict, "text", Js.Json.string(message))
    Js.Dict.set(dict,
      "hexPublicKey", Js.Json.string(orgId.hexPublicKey))
    Js.Dict.set(dict, "hexTimestamp", Js.Json.string(hexTimestamp))
    Js.Dict.set(dict, "hexSignedTimestamp", Js.Json.string(hexSignedTimestamp))
    Js.Json.object_(dict)
  }

  X.post(relay_url, data)
  -> ignore
}
