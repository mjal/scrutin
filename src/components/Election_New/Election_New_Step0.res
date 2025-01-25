@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let {t} = ReactI18next.useTranslation()
  let (title, setTitle) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")

  let next = _ => {
    setState(_ => {
      ...state,
      step: Step0b,
      title,
      desc,
    })
  }

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.Section title={t(. "election.new.title")} />

      <S.TextInput
        testID="election-title"
        value=title
        placeholder=t(. "election.new.titlePlaceholder")
        placeholderTextColor="#bbb"
        autoFocus=true
        onChangeText={text => setTitle(_ => text)}
      />

      <View style=Style.viewStyle(~margin=15.0->Style.dp, ()) />

      <S.TextInput
        testID="election-description"
        value=desc
        placeholder="Description (optionelle)"
        placeholderTextColor="#bbb"
        multiline=true
        numberOfLines=5
        onChangeText={text => setDesc(_ => text)}
      />
    </S.Container>

    <S.Row>
      <S.Col>
        <></>
      </S.Col>
      <S.Col>
        <S.Button
          title={t(. "election.new.next")}
          disabled=(title == "")
          onPress=next
          />
      </S.Col>
    </S.Row>
  </>
}

