@react.component
let make = (~title, ~answers, ~setAnswers) => {
  // let {t} = ReactI18next.useTranslation()

  let onRemove = i => {
    setAnswers(answers => Array.keepWithIndex(answers, (_name, index) => index != i))
  }

  let onUpdate = (i, newName) => {
    setAnswers(answers =>
      Array.mapWithIndex(answers, (index, oldName) => {
        index == i ? newName : oldName
      })
    )
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
      onPress={_ => setAnswers(choices => Array.concat(choices, [""]))}>
      <SIcon.ButtonPlus />
    </TouchableOpacity>
  </View>
}
