@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()

  //let setVotingMethod = votingMethod => {
  //  setState(_ => { ...state, votingMethod })
  //}

  let next = _ => setState(_ => {...state, step: Step2 })
  let previous = _ => setState(_ => {...state, step: Step0c })

  let options : array<RadioButtonGroup.option_t> = [
    {
      value: "uninominal",
      title: <RadioButtonGroup.SimpleTitle text="Vote classique" />,
      content: <RadioButtonGroup.SimpleContent text="Les participants peuvent choisir un choix par question (scrutin uninominal)." />
    },
    {
      value: "majorityJudgement",
      title: <RadioButtonGroup.SimpleTitle text="Vote par jugement majoritaire" />,
      content: <RadioButtonGroup.SimpleContent text="Les participants doivent classer chaque candidat sur un échelle." />
    }
  ]

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <S.H1 text ="Choisissez le type de scrutin" />

      <RadioButtonGroup
        value=Election.votingMethodToString(state.votingMethod)
        onValueChange={ v => {
          let votingMethod = Election.stringToVotingMethod(v)
          setState(_ => {...state, ?votingMethod});
          v
        }}
        options
        />
    </S.Container>

    <Election_New_Previous_Next next previous disabled=Option.isNone(state.votingMethod) />
  </>
}

