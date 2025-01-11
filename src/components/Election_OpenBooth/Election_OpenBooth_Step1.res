@react.component
let make = (~electionData: ElectionData.t, ~state: Election_OpenBooth_State.t, ~dispatch) => {
  let _ = state
  <>
    <Header title="Participer à l'élection" />

    <Logo />

    <Title>
      { electionData.setup.election.name -> React.string }
    </Title>

    <S.Button
      title="Je participe"
      onPress={_ => dispatch(Election_OpenBooth_State.SetStep(Step2))}
    />
  </>
}
