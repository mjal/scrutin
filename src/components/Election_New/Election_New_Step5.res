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
  let description = ""
  let { title, questions } = state
  let election = React.useMemo(() => {
    Election.create(description, Option.getExn(title), trustees, questions)
  })
  let access = Election_New_State.accessToString(state.access)
  let election = {...election, access}

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
    let _response = await X.put(`${URL.bbs_url}/${election.uuid}`, obj)
    globalDispatch(StateMsg.Navigate(list{"elections", election.uuid}))
  }

  <>
    <Header title="Nouvelle élection" subtitle="5/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

    { switch policy {
    | None =>
      <Election_New_Step5_Menu updatePolicy=setPolicy />
    | Some(#local) =>
      ReactNativeAsyncStorage.setItem(election.uuid, mnemonic)->ignore

      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Le mot de passe a été sauvegardé sur cet appareil." -> React.string }
        </Text>

        <Text style={S.flatten([S.title, Style.textStyle(~color=Color.darkorange, ~fontWeight=Style.FontWeight.bold, ()), Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Vous devrez utiliser cet appareil lors du dépouillement." -> React.string }
        </Text>
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
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Cliquez ici pour télécharger un fichier contenant le mot de passe de dépouillement." -> React.string }
        </Text>

        <S.Button
          title={"Télécharger"}
          onPress={_ => download()->ignore }
          />

        <Text style={S.flatten([S.title, Style.viewStyle(~marginTop=20.0->Style.dp, ())])}>
          { "Une fois le mot de passe sauvegardé, vous pouvez passer à la suite" -> React.string }
        </Text>
      </>
    | Some(#extern) =>
      <>
        <Text style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ())])}>
          { "Voici le mot de passe à sauvegarder :" -> React.string }
        </Text>

        <Text selectable=true style={S.flatten([S.title, Style.viewStyle(~margin=20.0->Style.dp, ~borderColor=Color.green, ~borderWidth=4.0, ())])}>
          { mnemonic -> React.string }
        </Text>

        <Text style={S.flatten([S.title, Style.viewStyle(~marginTop=20.0->Style.dp, ())])}>
          { "Une fois le mot de passe sauvegardé, vous pouvez passer à la suite" -> React.string }
        </Text>
      </>
    } }

    { switch policy {
    | None => <></>
    | _ =>
      <View
        style=Style.viewStyle(
          ~flexDirection=#row,
          ~justifyContent=#"space-between",
          ~marginTop=20.0->Style.dp,
          (),
        )
      >
        <S.Button
          title="Précédent"
          titleStyle=Style.textStyle(~color=Color.black, ())
          mode=#outlined
          onPress={_ => setPolicy(_ => None)}
        />

        <S.Button
          title={t(. "election.new.next")}
          onPress={_ => create()->ignore}
        />
      </View>
    } }
  </>
}
