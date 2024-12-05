let rec reducer = (state: State.t, action: StateMsg.t) => {
  switch action {
  | Reset => (
      State.initial,
      [
        StateEffect.loadAccounts,
        StateEffect.loadTrustees,
        StateEffect.loadInvitations,
        //StateEffect.loadAndFetchEvents,
        StateEffect.goToUrl,
      ],
    )

  | FetchLatest =>
    let latestId = state.events
      ->Array.reduce(0, (acc, ev) => acc > ev.id ? acc : ev.id)
    (state, [StateEffect.fetchLatestEvents(latestId)])

  | Fetched => ({...state, fetchingEvents: false}, [])

  | Account_Add(account) =>
    let accounts = Array.concat(state.accounts, [account])
    ({...state, accounts}, [StateEffect.storeAccounts(accounts)])

  | Event_Add(event) =>
    if (state.events->Array.getBy(oldEvent => event.cid == oldEvent.cid)->Option.isSome)
    {
      Js.log("Duplicated event")
      (state, [])
    } else {
      //let events = Array.concat(state.events, [event])
      //let (elections, ballots) = StateEffect.electionsUpdate(state.elections, state.ballots, event)
      //({...state, events, elections, ballots}, [StateEffect.storeEvents(events)])
      (state, [])
    }

  | Event_Add_With_Broadcast(event) =>
    let (state, actions) = reducer(state, Event_Add(event))
    (state, Array.concat(actions, [StateEffect.broadcastEvent(event)]))

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [StateEffect.storeTrustees(trustees)])

  | Invitation_Add(invitation) =>
    let invitations = Array.concat(state.invitations, [invitation])
    ({...state, invitations}, [StateEffect.storeInvitations(invitations)])

  | Invitation_Remove(index) =>
    let invitations = Array.keepWithIndex(state.invitations, (_, i) => i != index)
    ({...state, invitations}, [StateEffect.storeInvitations(invitations)])

  | ElectionInit(uuid, election) =>
    let elections = Map.String.set(state.elections, uuid, election)
    ({...state, elections}, [])

  | BallotAdd(_cid, ballot) =>
    let ballots = Array.concat(state.ballots, [ballot])
    ({...state, ballots}, [])

  | Config_Store_Language(language) => (state, [StateEffect.storeLanguage(language)])

  | Navigate(route) =>
    if ReactNative.Platform.os == #web {
      if route != RescriptReactRouter.dangerouslyGetInitialUrl().path {
        let path = Belt.List.reduce(route, "", (a, b) => a ++ "/" ++ b)
        let path = if path == "" {
          "/"
        } else {
          path
        }
        RescriptReactRouter.push(path)
      }
    }
    ({...state, route}, [])

  | Navigate_Back =>
    if ReactNative.Platform.os == #web {
      let () = %raw(`history.back()`)
      (state, [])
    } else {
      // At the moment we directly go home on mobile, as we don't store history
      ({...state, route: list{}}, [])
    }

  | Navigate_About =>
    if ReactNative.Platform.os == #web {
      let () = %raw(`window.location = "https://scrutin.app"`)
    } else {
      Linking.openURL("https://www.scrutin.app") -> ignore
    }
    (state, [])

  | UpdateNewElection(newElection) => ({...state, newElection}, [])

  | CreateOpenElection =>
    let { title, description, choices } = state.newElection
    let (_privkey, serializedTrustee) = Sirona.Trustee.create()
    let trustee = Sirona.Trustee.fromJSON(serializedTrustee)
    let question : Sirona.QuestionH.t =  {
      question: "Question",
      answers: choices,
      min: 1,
      max: 1
    }
    let election = Sirona.Election.create(title, description, [trustee], [question])
    let election = {...election, unrestricted: (state.newElection.mode == State.Open)}
    Js.log(election)
    (state, [
      StateEffect.uploadElection(election, [trustee], [])
    ])

  | UploadBallot(name, election, ballot) =>
    (state, [
      StateEffect.uploadBallot(name, election, ballot)
    ])

  | CreateClosedElection =>
    let { title, description, choices, emails } = state.newElection
    let (_privkey, serializedTrustee) = Sirona.Trustee.create()
    let trustee = Sirona.Trustee.fromJSON(serializedTrustee)
    let question : Sirona.QuestionH.t =  {
      question: "Question",
      answers: choices,
      min: 1,
      max: 1
    }
    Js.log(emails)
    let election = Sirona.Election.create(title, description, [trustee], [question])
    let election = {...election, unrestricted: (state.newElection.mode == State.Open)}
    Js.log("TODO")
    (state, [
      StateEffect.sendEmailsAndCreateElection(emails, election, [trustee], [])
    ])

  | ElectionFetch(uuid) =>
    let electionsTryFetch = Map.String.set(state.electionsTryFetch, uuid, true)
    ({...state, electionsTryFetch}, [StateEffect.fetchElection(uuid)])
  }
}
