@react.component
let make = () => {
  let (state, dispatch) = StateContext.use()
  let {t} = ReactI18next.useTranslation()

  let (title, setTitle) = React.useState(_ => "")

  let next = _ => {
    let newElection = {...state.newElection, title}
    dispatch(StateMsg.UpdateNewElection(newElection))
    dispatch(StateMsg.Navigate(list{"elections", "new", "step2"}))
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
