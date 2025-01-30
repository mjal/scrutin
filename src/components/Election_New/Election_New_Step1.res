@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()

  let setVotingMethod = votingMethod => {
    setState(_ => {
      ...state,
      votingMethod
    })
  }

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step2,
    })
  }

  let previous = _ => {
    setState(_ => {
      ...state,
      step: Step0c,
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <S.H1 text ="Choisissez le type de scrutin" />

      <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
        <RadioButton.Group
          value={Option.map(state.votingMethod, Election.votingMethodToString)->Option.getWithDefault("")}
          onValueChange={v => {
            let votingMethod = Election.stringToVotingMethod(v)
            setState(_ => {
              ...state,
              votingMethod
            })
            v
          }}
        >
          <TouchableOpacity onPress={_ => setVotingMethod(#uninominal)}>
            <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
              <RadioButton value="uninominal" status=(if state.votingMethod == Some(#uninominal) { #checked } else { #unchecked }) />
              <Text
                style=Style.textStyle(
                  ~color=Color.black,
                  ~fontSize=18.0,
                  ~fontWeight=Style.FontWeight._700,
                  (),
                )
              >
                { "Vote classique"->React.string }
              </Text>
            </View>
            <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
              {
                "Les participants peuvent choisir un choix par question (scrutin uninominal)."
                ->React.string
              }
            </Text>
          </TouchableOpacity>

          <View style=Style.viewStyle(~marginTop=16.0->Style.dp, ()) />

          <TouchableOpacity onPress={_ => setVotingMethod(#majorityJudgement)}>
            <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
              <RadioButton value="majorityJudgement" status=(if state.votingMethod == Some(#majorityJudgement) { #checked } else { #unchecked }) />
              <Text
                style=Style.textStyle(
                  ~color=Color.black,
                  ~fontSize=18.0,
                  ~fontWeight=Style.FontWeight._700,
                  (),
                )
              >
                { "Vote par jugement majoritaire"->React.string }
              </Text>
            </View>
            <Text style=Style.textStyle(~color=Color.gray, ~marginLeft=36.0->Style.dp, ())>
              {
                "Les participants doivent classer chaque candidat sur un échelle."
                ->React.string
              }
            </Text>
          </TouchableOpacity>
        </RadioButton.Group>
      </View>
    </S.Container>

    <Election_New_Previous_Next next previous disabled=Option.isNone(state.votingMethod) />
  </>
}

