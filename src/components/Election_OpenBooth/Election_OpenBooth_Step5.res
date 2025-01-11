@react.component
let make = (~electionData: ElectionData.t, ~state: Election_OpenBooth_State.t, ~dispatch) => {
  let (_, globalDispatch) = StateContext.use()
  let _ = (state, dispatch)
  let election = electionData.setup.election

  <>
    <Header title="A voté" />

    <Button icon=Paper.Icon.name("party-popper")>
      { "" -> React.string }
    </Button>

    <Title>
      { "A voté" -> React.string }
    </Title>

    <Text>
      { "Votre vote a bien été pris en compte" -> React.string }
    </Text>

    <S.Button
      title="Retour à l'élection"
      onPress={_ => {
        globalDispatch(Navigate(list{"elections", election.uuid}))
      }}
    />
  </>
}


