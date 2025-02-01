@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let next = _ => setState(_ => {...state, step: Step6})
  let previous = _ => setState(_ => {...state, passwordPolicy: ?None})
  let election = Option.getExn(state.election)
  let mnemonic = Option.getExn(state.mnemonic)

  React.useEffect0(_ => {
    ReactNativeAsyncStorage.setItem(election.uuid, mnemonic)->ignore
    None
  })

  <>
    <S.Container>
      <S.H1 text="Sauvegarde du mot de passe nécessaire au dépouillement" />

      <S.P text="Le mot de passe a été sauvegardé sur cet appareil." />
      <S.P text="Vous devrez utiliser cet appareil lors du dépouillement." style=Style.textStyle(~color=Color.darkorange, ~fontWeight=Style.FontWeight.bold, ()) />
    </S.Container>

    <Election_New_Previous_Next
      next
      previous
    />
  </>
}
