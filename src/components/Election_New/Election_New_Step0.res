@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let {t} = ReactI18next.useTranslation()
  let (title, setTitle) = React.useState(_ => "")

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step1,
      title: Some(title),
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

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
