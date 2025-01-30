@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let next = _ => setState(_ => {...state, step: Step6})
  let previous = _ => setState(_ => {...state, passwordPolicy: ?None})
  //let election = Option.getExn(state.election)
  let mnemonic = Option.getExn(state.mnemonic)

  <>
    <S.Container>
      <S.H1 text="Sauvegarde du mot de passe nécessaire au dépouillement" />

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
    </S.Container>

    <Election_New_Previous_Next
      next
      previous
    />
  </>
}
