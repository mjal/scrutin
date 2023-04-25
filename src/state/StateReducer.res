// The reducer, the only place where state mutations can happen
let reducer = (state: State.t, action: StateMsg.t) => {
  switch action {
  | Reset => (
      State.initial,
      [
        StateEffect.loadIdentities,
        StateEffect.loadTrustees,
        StateEffect.loadInvitations,
        StateEffect.fetchEvents,
        StateEffect.goToUrl,
      ],
    )

  | Fetching_Events_End => ({...state, fetchingEvents: false}, [])

  | Identity_Add(id) =>
    let ids = Array.concat(state.ids, [id])
    ({...state, ids}, [StateEffect.storeIdentities(ids)])

  | Event_Add(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [StateEffect.cacheUpdate(event)])

  | Event_Add_With_Broadcast(event) =>
    let events = Array.concat(state.events, [event])
    ({...state, events}, [StateEffect.broadcastEvent(event), StateEffect.cacheUpdate(event)])

  | Trustee_Add(trustee) =>
    let trustees = Array.concat(state.trustees, [trustee])
    ({...state, trustees}, [StateEffect.storeTrustees(trustees)])

  | Invitation_Add(invitation) =>
    let invitations = Array.concat(state.invitations, [invitation])
    ({...state, invitations}, [StateEffect.storeInvitations(invitations)])

  | Invitation_Remove(index) =>
    let invitations = Array.keepWithIndex(state.invitations, (_, i) => i != index)
    ({...state, invitations}, [StateEffect.storeInvitations(invitations)])

  | Cache_Election_Add(cid, election) =>
    let elections = Map.String.set(state.elections, cid, election)
    let electionLatestIds = switch election.originId {
    | Some(originId) => Map.String.set(state.electionLatestIds, originId, cid)
    | None => state.electionLatestIds
    }
    ({...state, elections, electionLatestIds}, [])

  | Cache_Ballot_Add(_cid, ballot) =>
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
