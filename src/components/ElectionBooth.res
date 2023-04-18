module Choice = {
  @react.component
  let make = (~name, ~selected, ~onSelect) => {
    let iconName = selected ? "radiobox-marked" : "radiobox-blank"

    <List.Item title=name
      left={_ => <List.Icon icon=Icon.name(iconName) />}
      onPress={_ => onSelect()}
    />
  }
}

@react.component
let make = (~ballot:Ballot.t, ~ballotId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (choice, setChoice) = React.useState(_ => None)

  let election = switch State.getElection(state, ballot.electionId) {
  | Some(election) => election
  | _ => Js.Exn.raiseError("Election not found") // TODO: Handle this
  }

  let question = switch Election.description(election) {
  | "" => t(."election.new.question")
  | question => question
  }

  <>
    <View style=S.questionBox>
      <S.Section title=question />
      { Array.mapWithIndex(Election.choices(election), (i, choiceName) => {
        let selected = choice == Some(i) 

        <Choice name=choiceName selected key=Int.toString(i)
          onSelect={_ => setChoice(_ => Some(i))} />
      }) -> React.array }
    </View>

    <Button mode=#contained onPress={_ => {
      let nbChoices = Array.length(Election.choices(election))
      Core.Ballot.vote(~ballot, ~previousId=ballotId,  ~choice, ~nbChoices)(state, dispatch)
    }}>
      { t(."ballot.new.vote") -> React.string }
    </Button>
  </>
}
