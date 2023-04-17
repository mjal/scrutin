@react.component
let make = (
  ~election: Election.t,
  ~section=#index: [#index | #invite]
) => {
  let { t } = ReactI18next.useTranslation()

  let title = switch Election.name(election) {
  | "" => t(."election.show.unnamed")
  | electionName => electionName
  }

  let titleTextStyle = switch Election.name(election) {
  | "" => Style.textStyle(~color=Color.grey, ())
  | _  => Style.textStyle()
  }

  let subtitle = switch section {
  | #invite => "Ajouter des votants" // TODO: i18n
  | _ => ""
  }

  <Header title titleTextStyle subtitle />
}
