let rec reducer = (state: State.t, action: StateMsg.t) => {
  switch action {
  | Reset => (
      State.initial,
      [
        StateEffect.loadAccounts,
        StateEffect.loadTrustees,
        StateEffect.loadInvitations,
        StateEffect.fetchEvents,
        StateEffect.goToUrl,
      ],
    )

  | Fetching_Events_End => ({...state, fetchingEvents: false}, [])

  | Account_Add(account) =>
    let accounts = Array.concat(state.accounts, [account])
    ({...state, accounts}, [StateEffect.storeAccounts(accounts)])

  | Event_Add(event) =>
    let events = Array.concat(state.events, [event])
    let (elections, ballots) = StateEffect.electionsUpdate(state.elections, state.ballots, event)
    ({...state, events, elections, ballots}, [])

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

  | ElectionInit(cid, election) =>
    let elections = Map.String.set(state.elections, cid, {...election,
      electionId: Some(cid)
    })
    ({...state, elections}, [])

  | ElectionUpdate(cid, election) =>
    let elections = Map.String.set(state.elections, cid, election)
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
  }
}
