@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let next = _ => setState(_ => {...state, step: Step6})
  let previous = _ => setState(_ => {...state, passwordPolicy: ?None})
  let election = Option.getExn(state.election)
  let mnemonic = Option.getExn(state.mnemonic)
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
    <S.Container>
      <S.H1 text="Sauvegarde du mot de passe nécessaire au dépouillement" />

      <S.P text="Cliquez ici pour télécharger un fichier contenant le mot de passe de dépouillement." />

      <S.Button
        title={"Télécharger"}
        onPress={_ => download()->ignore }
        />
  
      <S.P text="Une fois le mot de passe sauvegardé, vous pouvez passer à la suite" />
    </S.Container>

    <Election_New_Previous_Next
      next
      previous
    />
  </>
}
