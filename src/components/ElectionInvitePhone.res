module Item = {
  @react.component
  let make = (~onRemove, ~onUpdate, ~phone, ~index) => {
    <S.Row style={Style.viewStyle(~marginHorizontal=Style.dp(20.0), ())}>
      <S.Col style={Style.viewStyle(~flexGrow=10.0, ())}>
        <TextInput
          mode=#flat value=phone onChangeText=onUpdate
          label={`Phone ${index->Int.toString}`} testID={`input-invite-phone-${index->Int.toString}`}
        />
      </S.Col>
      <S.Col>
        <Button onPress=onRemove>
          <List.Icon icon={Icon.name("delete")} />
        </Button>
      </S.Col>
    </S.Row>
  }
}

@react.component
let make = (~election: Election.t, ~electionId) => {
  //let { t } = ReactI18next.useTranslation()
  let (state, dispatch) = StateContext.use()
  let (phones, setPhones) = React.useState(_ => ["", ""])
  let admin = state->State.getElectionAdminExn(election)
  let (sendInvite, setSendInvite) = React.useState(_ => true)

  let onSubmit = _ => {
    phones
    ->Array.keep(phone => phone != "")
    ->Array.forEach(phone => {
      InviteQuery.send(dispatch, admin, "phone", phone, electionId, sendInvite)
    })
  }

  let onRemove = i => {
    setPhones(Array.keepWithIndex(_, (_, index) => index != i))
  }

  let onUpdate = (i, newPhone) => {
    setPhones(phones =>
      Array.mapWithIndex(phones, (index, oldPhone) => {
        index == i ? newPhone : oldPhone
      })
    )
  }

  <>
    <ElectionHeader election section=#inviteMail />
    {Array.mapWithIndex(phones, (i, phone) => {
      <Item
        phone
        index={i + 1}
        key={Int.toString(i)}
        onRemove={_ => onRemove(i)}
        onUpdate={phone => onUpdate(i, phone)}
      />
    })->React.array}
    <S.Button
      style={Style.viewStyle(~width=100.0->Style.dp, ())}
      title="+"
      onPress={_ => setPhones(phones => Array.concat(phones, [""]))}
    />
    <List.Item
      title="Envoyer une invitation"
      description="Tous les participants recevront un SMS"
      onPress={_ => setSendInvite(b => !b)}
      right={_ => <Switch value=sendInvite />}
    />
    <S.Button onPress=onSubmit title="Inviter" />
  </>
}

