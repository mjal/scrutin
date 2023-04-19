@react.component
let make = (
  ~election: Election.t,
  ~section=#index
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
  | #index => ""
  | #invite => "Ajouter des votants"
  | #inviteLink => "Invitation par lien"
  | #inviteMail => "Invitation mail"
  | #result => "Résultats"
  }

  <Header title titleTextStyle subtitle />
}
