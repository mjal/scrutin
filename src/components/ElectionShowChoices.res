@react.component
let make = (~election: Sirona.Election.t) => { <></> }
//@react.component
//let make = (~election: Sirona.Election.t) => {
//  let {t} = ReactI18next.useTranslation()
//
//  let question = switch election.name {
//  | "" => t(. "election.new.question")
//  | question => question
//  }
//
//  <View style=S.questionBox>
//    <S.Section title=question />
//    {Array.mapWithIndex(election.questions[0].answers, (i, name) => {
//      <List.Item title=name key={Int.toString(i)} />
//    })->React.array}
//  </View>
//}
