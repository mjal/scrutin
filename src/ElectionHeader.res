@react.component
let make = (~election: Election.t) => {
  let { t } = ReactI18next.useTranslation()

  let title = switch Election.name(election) {
  | "" => t(."election.show.unnamed")
  | electionName => electionName
  }

  let titleTextStyle = switch Election.name(election) {
  | "" => Style.textStyle(~color=Color.grey, ())
  | _  => Style.textStyle()
  }


  <Header title titleTextStyle />
}
