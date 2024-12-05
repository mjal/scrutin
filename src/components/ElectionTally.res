@react.component
let make = (~election: Sirona.Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()
  let (passphrase, setPassphrase) = React.useState(_ => "")

  <>
    <ElectionHeader election />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <Title>
      { "Entrer la phrase de passe" -> React.string }
    </Title>

    <S.TextInput
      value=passphrase
      onChangeText={text => setPassphrase(_ => text)}
    />

    <S.Button
      title="Dépouiller"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId, "tally"}))
      }
    />

    <View style={Style.viewStyle(~height=20.0->Style.dp, ())} />

    <S.Button
      title="Retour"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId}))
      }
    />
  </>
}
