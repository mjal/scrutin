@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let {t} = ReactI18next.useTranslation()

  let next = _ => setState(_ => { ...state, step: Step0b, })

  <>
    <Header title="Nouvelle élection" subtitle="1/5" />

    <S.Container>
      <View style=Style.viewStyle(~margin=30.0->Style.dp, ()) />

      <S.Section title={t(. "election.new.title")} />

      <S.TextInput
        testID="election-title"
        value=state.title
        placeholder=t(. "election.new.titlePlaceholder")
        placeholderTextColor="#bbb"
        autoFocus=true
        onSubmitEditing=next
        onChangeText={title => setState(_ => {...state, title})}
      />

      <View style=Style.viewStyle(~margin=15.0->Style.dp, ()) />

      <S.TextInput
        testID="election-description"
        value=state.desc
        placeholder="Description (optionelle)"
        placeholderTextColor="#bbb"
        multiline=true
        numberOfLines=5
        onChangeText={desc => setState(_ => {...state, desc})}
      />
    </S.Container>

    <S.Row>
      <S.Col>
        <></>
      </S.Col>
      <S.Col>
        <S.Button
          title={t(. "election.new.next")}
          disabled=(state.title == "")
          onPress=next
          />
      </S.Col>
    </S.Row>
  </>
}

