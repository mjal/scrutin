@react.component
let make = (~electionData: ElectionData.t) => {
  //let { t } = ReactI18next.useTranslation()
  let (_state, dispatch) = StateContext.use()
  let { setup } = electionData
  let election = setup.election
  let inviteUrl = `${URL.base_url}/elections/${election.uuid}/openbooth`

  <>
    <Header title="Inviter à l'élection" />

    <View style=Style.viewStyle(~marginTop=30.0->Style.dp, ())>
    </View>

    <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ())>
      { `${election.name}`->React.string }
    </Title>

    <View style={Style.viewStyle(~margin=30.0->Style.dp, ())}>
      <S.TextInput onChangeText={_ => ()} value=inviteUrl testID="input-invite-link" />
    </View>
    <CopyButton text=inviteUrl />
    {
      if ReactNative.Platform.os != #web {
        <S.Button
          onPress={_ => {
            Share.share({message: inviteUrl})->ignore
          }}
          title="Partager"//{t(. "election.show.createInvite.share")}
        />
      } else {
        <></>
      }
    }
    <S.Button
      title="Précédent"
      titleStyle=Style.textStyle(~color=Color.black, ())
      mode=#outlined
      onPress={_ => dispatch(Navigate(list{"elections", election.uuid}))}
      //style=Style.viewStyle(~width=120.0->Style.dp, ())
    />
  </>
}

