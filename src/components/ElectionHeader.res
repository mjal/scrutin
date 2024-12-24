@react.component
let make = (~election: Election.t, ~section=#index) => {
  let {t} = ReactI18next.useTranslation()

  Js.log(election.description)

  let title = switch election.description {
  | "" => t(. "election.show.unnamed")
  | electionName => electionName
  }

  let titleTextStyle = switch election.description {
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
