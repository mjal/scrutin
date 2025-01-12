type policy_t = [ #local | #file | #extern ]

@react.component
let make = (~state: Election_New_State.t, ~dispatch) => {
  let { t } = ReactI18next.useTranslation()
  let (_globalState, globalDispatch) = StateContext.use()
  let (policy : option<policy_t>, setPolicy) = React.useState(_ => None)
  let _ = dispatch

  let words = React.useMemo(() => {
    Array.init(12, _ => {
      let index = Sjcl.BitArray.extract(Sjcl.Random.randomWords(1),0,31)
      let index = mod(index, 2048)
      Array.getExn(Wordlist.english, index)
    })
  })
  let mnemonic = Js.Array.joinWith(" ", words)

  let hash = Sjcl.Sha256.hash(mnemonic)
  let privkey = Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))
  let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
  let trustee = Trustee.fromJSON(serializedTrustee)
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
    let obj : Js.Json.t = Obj.magic({"setup": Setup.serialize(setup)})
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
          //style=Style.viewStyle(~width=120.0->Style.dp, ())
        />

        <S.Button
          title={t(. "election.new.next")}
          onPress={_ => create()->ignore}
          //style=Style.viewStyle(~width=120.0->Style.dp, ())
        />
      </View>
    } }
  </>
}
