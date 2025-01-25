type policy_t = [ #local | #file | #extern ]

@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let { t } = ReactI18next.useTranslation()
  let (_globalState, globalDispatch) = StateContext.use()
  let (policy : option<policy_t>, setPolicy) = React.useState(_ => None)
  let _ = setState

  let mnemonic = Mnemonic.generate()
  let privkey = Mnemonic.toPrivkey(mnemonic)
  let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
  let trustee = Trustee.parse(serializedTrustee)
  let trustees = [trustee]
  let { questions } = state
  let election = React.useMemo(() => {
    switch (state.title, state.desc) {
    | (Some(title), Some(desc)) => Election.create(desc, title, trustees, questions)
    | _ => Js.Exn.raiseError("title and desc must be set")
    }
  })
  let access = Option.getWithDefault(state.access, #"open")
  let votingMethod = Option.getWithDefault(state.votingMethod, #uninominal)

  let election = {
    ...election,
    access,
    votingMethod,
    startDate: ?state.startDate,
    endDate: ?state.endDate,
  }

  let create = async _ => {
    let setup : Setup.t = {
      election,
      trustees,
      credentials: []
    }

    let { election } = setup
    let obj : Js.Json.t = Obj.magic({
      "setup": Setup.serialize(setup),
      "emails": state.emails
    })
    let _response = await HTTP.put(`${Config.server_url}/${election.uuid}`, obj)
    globalDispatch(StateMsg.Navigate(list{"elections", election.uuid}))
  }

  <>
    <Header title="Nouvelle élection" subtitle="5/5" />

    <S.Container>
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      { switch policy {
      | None =>
        <Election_New_Step5_Menu updatePolicy=setPolicy />
      | Some(#local) =>
        ReactNativeAsyncStorage.setItem(election.uuid, mnemonic)->ignore
        <>
          <S.P text="Le mot de passe a été sauvegardé sur cet appareil." />
          <S.P text="Vous devrez utiliser cet appareil lors du dépouillement." style=Style.textStyle(~color=Color.darkorange, ~fontWeight=Style.FontWeight.bold, ()) />
        </>
      | Some(#file) =>
        let download = async _ => {
          if ReactNative.Platform.os == #web {
            let download_helper = %raw(`function(content, filename) {
                let blob = new Blob([content], {"type": "text/plain"})
                let url = URL.createObjectURL(blob)
                let a = document.createElement("a")
                a.href = url
                a.download = filename
                a.click()
                URL.revokeObjectURL(url)
              }`)
            download_helper(mnemonic, `election-password-${election.uuid}.txt`)
          } else {
            let fileUri = FileSystem.documentDirectory ++ "example.json"
            await FileSystem.writeAsStringAsync(fileUri, mnemonic)
          }
        }

        <>
          <S.P text="Cliquez ici pour télécharger un fichier contenant le mot de passe de dépouillement." />

          <S.Button
            title={"Télécharger"}
            onPress={_ => download()->ignore }
            />

          <S.P text="Une fois le mot de passe sauvegardé, vous pouvez passer à la suite" />
        </>
      | Some(#extern) =>
        <>
          <S.P text="Voici le mot de passe à sauvegarder :" />

          <Text selectable=true style={S.flatten([
            Style.textStyle(
              ~fontFamily="Inter_400Regular",
              ~textAlign=#center, ~fontSize=20.0, ~color=Color.black, ()),
            Style.viewStyle(~margin=20.0->Style.dp, ~borderColor=Color.green, ~borderWidth=4.0, ())
          ])}>
            { mnemonic -> React.string }
          </Text>

          <S.P text="Une fois le mot de passe sauvegardé, vous pouvez passer à la suite"  />
        </>
      } }
    </S.Container>

    { switch policy {
    | None => <></>
    | Some(_) =>
      <Election_New_Previous_Next
        next={_ => create()->ignore}
        previous={_ => setPolicy(_ => None)} />
    } }
  </>
}
