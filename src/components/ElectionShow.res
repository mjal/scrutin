@react.component
let make = (~setup: Setup.t, ~electionId) => {
  let (_state, dispatch) = StateContext.use()
  Js.log(1)
  Js.log(setup)
  let election = setup.election

  <>
    <ElectionHeader election />
    <View>
      <ElectionShowChoices election />
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

    <View style={Style.viewStyle(~height=30.0->Style.dp, ())} />

    <S.Button
      title="Voter"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId, "booth"}))
      }
    />

    <S.Button
      title="Admin: dépouillement"
      onPress={_ =>
        dispatch(Navigate(list{"elections", electionId, "tally"}))
      }
    />
  </>
}
