@react.component
let make = (~title, ~answers, ~updateAnswers) => {
  // let {t} = ReactI18next.useTranslation()

  let onRemove = i => {
    updateAnswers(Array.keepWithIndex(answers, (_name, index) => index != i))
  }

  let onUpdate = (i, newName) => {
    let answers = Array.mapWithIndex(answers, (index, oldName) => {
      index == i ? newName : oldName
    })
    updateAnswers(answers)
  }

  <View testID="choice-list">
    <S.Section title />
    {Array.mapWithIndex(answers, (i, name) => {
      <Election_New_ChoiceItem
        name
        index={i + 1}
        key={Int.toString(i)}
        onRemove={_ => onRemove(i)}
        onUpdate={name => onUpdate(i, name)}
      />
    })->React.array}
    <TouchableOpacity
      //style=Style.viewStyle(~alignSelf=#center,())
      style=Style.viewStyle(~marginLeft=60.0->Style.dp, ())
      onPress={_ => updateAnswers(Array.concat(answers, [""]))}>
      <SIcon.ButtonPlus />
    </TouchableOpacity>
  </View>
}
