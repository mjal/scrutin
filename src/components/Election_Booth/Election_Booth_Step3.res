module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item
      title=name
      style={Style.viewStyle(~padding=20.0->Style.dp, ~paddingLeft=40.0->Style.dp, ())}
      left={_ => <List.Icon icon={Icon.name(iconName)} />}
      onPress={_ => onSelect()}
    />
  }
}

@react.component
let make = (~electionData: ElectionData.t, ~state: Election_Booth_State.t, ~setState) => {
  let _ = state
  let election = electionData.setup.election
  let nQuestions = Array.length(election.questions)
  let (choices, setChoices) = React.useState(_ => {
    let default = Array.init(nQuestions, _ => None)
    Option.getWithDefault(state.choices, default)
  })

  let next = _ => {
    setState(_ => {
      ...state,
      choices: Some(choices),
      step: Step4
    })
  }

  let previous = _ => setState(_ => {
    ...state,
    choices: None,
    step: Step2
  })

  <>
    <Header title="Mon choix" />

    <S.Container>
    {Array.mapWithIndex(election.questions, (j, question) => {
      let choice = Array.getExn(choices, j)
      <View key={Int.toString(j)}>
        <View style=S.questionBox>
          <S.Section title=question.question />
          {Array.mapWithIndex(question.answers, (i, name) => {
            let onSelect = _ => {
              let choices = Array.mapWithIndex(choices, (k, c) => {
                if j == k {
                  Some(i)
                } else {
                  c
                }
              })
              setChoices(_ => choices)
            }
            let selected = choice == Some(i)
            <Choice name selected key={Int.toString(i)} onSelect />
          })->React.array}
        </View>
        <View style={Style.viewStyle(~marginTop=-30.0->Style.dp, ())}>
          <View style={Style.viewStyle(~position=#absolute, ~right=30.0->Style.dp, ())}>
            <Text
              style={Style.textStyle(
                ~width=switch ReactNative.Platform.os {
                | #web => 80.0->Style.dp
                | _ => 120.0->Style.dp
                },
                ~backgroundColor=S.primaryColor,
                ~color=Color.white,
                ~paddingBottom=5.0->Style.dp,
                ~paddingLeft=8.0->Style.dp,
                (),
              )}>
              {"Vote privé"->React.string}
            </Text>
          </View>
        </View>
      </View>
    })->React.array}

    </S.Container>
    {
      let style = Style.viewStyle(
        ~flexDirection=#row,
        ~justifyContent=#"space-between",
        ~marginTop=20.0->Style.dp,
        ())

      <View style>
        <S.Button
          title="Précédent"
          titleStyle=Style.textStyle(~color=Color.black, ())
          mode=#outlined
          onPress={_ => previous()}
        />

        <S.Button
          title="Confirmer mon choix"
          disabled=(Array.some(choices, Option.isNone))
          onPress=next
        />
      </View>
    }
  </>
}

