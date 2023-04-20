@react.component
let make = (~election:Election.t, ~electionId) => {
  let (state, dispatch) = StateContext.use()

  let ballots = 
    state.ballots
    -> Map.String.keep((_ballotId, ballot) =>
      ballot.electionId == electionId
    )
    -> Map.String.keep((_ballotId, ballot) =>
      state.ids
      -> Array.some((id) => {
        id.hexPublicKey == ballot.voterPublicKey
      })
    )

  let nbVotes =
    Map.String.toArray(state.ballots)
    -> Array.keep(((_id, ballot)) =>
      ballot.electionId == electionId)
    -> Array.keep(((id, _ballot)) => {
      Map.String.get(state.ballotReplacementIds, id)
      -> Option.isNone
    })
    -> Array.keep(((_id, ballot)) => {
      Option.isSome(ballot.ciphertext)
    }) -> Array.length

  let styles = {
    open Style
    StyleSheet.create({
      "choiceEditButton": viewStyle(
        ~position=#absolute,
        ~top=0.0->dp,
        ~right=0.0->dp,
        ~width=100.0->dp,
        ~backgroundColor=S.primaryColor,
        ()),
      "choiceListView": viewStyle(())
    })
  }

  <>
    <ElectionHeader election />

    <View>
      <ElectionShowChoices election />
      { switch Map.String.isEmpty(ballots) {
      | true => <></>
      | false =>
        <IconButton
          icon=Icon.name("square-edit-outline")
          style=styles["choiceEditButton"]
          onPress={_ => {
            let (ballotId, _ballot) =
              Option.getExn(Map.String.minimum(ballots))
            dispatch(Navigate(list{"ballots", ballotId}))
          }}
        />
      } }
    </View>
    <View style=Style.viewStyle( ~marginTop=-30.0->Style.dp, ())>
      <View style=Style.viewStyle(
        ~position=#absolute,
        ~right=30.0->Style.dp,
        ())>
      <Text style=Style.textStyle(
        ~width=80.0->Style.dp,
        ~backgroundColor=S.primaryColor,
        ~color=Color.white,
        ~paddingBottom=5.0->Style.dp,
        ~paddingLeft=8.0->Style.dp,
        ())>
        { "Vote privé" -> React.string }
      </Text>
      </View>
    </View>

    { switch election.result {
    | Some(_) =>
      <S.Button title="Afficher le résultat" onPress={_ =>
        dispatch(Navigate(list{"elections", electionId, "result"}))
      } />
    | None =>
      switch State.getAccount(state, election.ownerPublicKey) {
      | None => <></>
      | Some(_adminAccount) =>
      <>
        <S.Button title="Ajouter des votants" onPress={_ => 
          dispatch(Navigate(list{"elections", electionId, "invite"}))
        } /> // TODO: i18n

        //<Button mode=#text onPress={_ =>
        //  dispatch(Navigate(list{"elections", electionId, "invite"}))
        //}>
        //  { "Gérer les invitations" -> React.string }
        //</Button>

        //<Divider />

        <S.Button title=`Calculer le résultat des ${nbVotes->Int.toString} votes` onPress={_ =>
          Core.Election.tally(~electionId)(state, dispatch)
        } />
      </>
      }
    }
  }
  </>
}
