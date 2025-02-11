@react.component
let make = (~title, ~answers, ~updateAnswers, ~removeQuestion=?) => {
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

      <S.Row>
        <S.Col>
          <S.Button
            title="Nouvelle option"
            onPress={_ => updateAnswers(Array.concat(answers, [""]))}
          />
        </S.Col>
        <S.Col>
          {switch removeQuestion {
          | Some(removeQuestion) =>
            <S.Button
              title="Remove question"
              titleStyle=Style.textStyle(~color=Color.black, ())
              mode=#outlined
              onPress={_ => removeQuestion()}
            />
          | None => <></>
          }}
        </S.Col>
      </S.Row>
  </View>
}
