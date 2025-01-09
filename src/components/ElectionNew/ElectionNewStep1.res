@react.component
let make = (~state: ElectionNewState.t, ~dispatch) => {
  let {t} = ReactI18next.useTranslation()

  let (title, setTitle) = React.useState(_ => "")

  let next = _ => {
    dispatch(ElectionNewState.SetTitle(title))
    dispatch(ElectionNewState.SetStep(Step2))
  }

  <>
    <Header title={t(. "election.new.header")} />
    <S.Section title={t(. "election.new.title")} />
    <S.TextInput
      testID="election-title"
      value=title
      placeholder=t(. "election.new.titlePlaceholder")
      placeholderTextColor="#bbb"
      autoFocus=true
      onSubmitEditing=next
      onChangeText={text => setTitle(_ => text)}
    />

    <S.Button
      title={t(. "election.new.next")}
      disabled=(title == "")
      onPress=next
      />
  </>
}

