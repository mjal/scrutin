@react.component
let make = (~election: Sirona.Election.t, ~section=#index) => {
  let {t} = ReactI18next.useTranslation()

  let title = switch election.name {
  | "" => t(. "election.show.unnamed")
  | electionName => electionName
  }

  let titleTextStyle = switch election.name {
  | "" => Style.textStyle(~color=Color.grey, ())
  | _ => Style.textStyle()
  }

  let subtitle = switch section {
  | #index => ""
  | #invite => "Ajouter des votants"
  | #inviteLink => "Invitation par lien"
  | #inviteMail => "Invitation mail"
  | #inviteManage => "Manage invitations"
  | #result => "Résultats"
  }

  <Header title titleTextStyle subtitle />
}
