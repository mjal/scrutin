@react.component
let make = (~state: Election_New_State.t, ~setState) => {
  let (error, setError) = React.useState(_ => false)
  let trustees = Option.getExn(state.trustees)
  let election = Option.getExn(state.election)
  let (_, globalDispatch) = StateContext.use()

  let create = async _ => {
    let setup : Setup.t = {
      election,
      trustees,
      credentials: []
    }

    let obj : Js.Json.t = Obj.magic({
      "setup": Setup.serialize(setup),
      "emails": state.emails
    })

    let response = await HTTP.put(`${Config.server_url}/${election.uuid}`, obj)
    let status = Webapi.Fetch.Response.status(response)
    switch status {
    | 200 | 201 =>
      globalDispatch(StateMsg.Navigate(list{"elections", election.uuid}))
    | _ =>
      Js.log("Error...")
      setError(_ => true)
    }
  }

  let previous = _ => setState(_ => {...state, step: Step_Password})

  <>
    <Header title="Nouvelle élection" subtitle="Dernière étape" />

    <S.Container>
      <S.H1 text="Tout est prêt ! Créer l'élection ?" />

      { if error {
        <S.P text="Il y a eu une erreur en essayant de créer l'élection..." />
      } else { <></> } }
    </S.Container>

    <Election_New_Previous_Next next={_ => create()->ignore} previous />
  </>
}
