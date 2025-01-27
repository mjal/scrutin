@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  //let { t } = ReactI18next.useTranslation()
  let (votingMethod, setVotingMethod) = React.useState(_ => #uninominal)

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step2,
      votingMethod,
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
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <Title style=Style.textStyle(~color=Color.black, ~fontSize=40.0, ~fontWeight=Style.FontWeight._900, ~margin=30.0->Style.dp, ())>
        { "Comment on y participe ?" -> React.string }
      </Title>

      <View style=Style.viewStyle(~padding=16.0->Style.dp, ())>
        <RadioButton.Group
          value={Election.votingMethodToString(votingMethod)}
          onValueChange={v => {
            setVotingMethod(_ => Election.stringToVotingMethod(v))
            v
          }}
        >
          <TouchableOpacity onPress={_ => setVotingMethod(_ => #uninominal)}>
            <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
              <RadioButton value="uninominal" status=(if votingMethod == #uninominal { #checked } else { #unchecked }) />
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

          <TouchableOpacity onPress={_ => setVotingMethod(_ => #majorityJudgement)}>
            <View style=Style.viewStyle(~flexDirection=#row, ~alignItems=#center, ())>
              <RadioButton value="majorityJudgement" status=(if votingMethod == #majorityJudgement { #checked } else { #unchecked }) />
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

    <Election_New_Previous_Next next previous />
  </>
}

