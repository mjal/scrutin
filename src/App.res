open Helper
open ReactNative;
open Paper;

let styles = {
  open Style
  StyleSheet.create({
    "view": viewStyle(
      ~alignItems=#center,
      ~padding=dp(20.),
    ()),
    "text": textStyle(
      ~fontSize=30.,
    ()),
  })
}

@react.component
let make = () => {
  let (state, dispatch) =
    React.useReducer(State.reducer, State.initialState)

  let onPress = () => ()

  <Paper.PaperProvider>
	  <View>
      {
        open Appbar
        <Header>
          {/*<BackAction onPress />*/""->rs}
          <Content title={"Scrutin"->rs} />
          {/*<Action icon="calendar" onPress />*/""->rs}
          <Action onPress />
        </Header>
      }

      <View style={styles["view"]}>
        <Paper.Text style={styles["text"]}>
          {rs("end to end encrypted")}
        </Paper.Text>
        <Paper.Text style={styles["text"]}>
          {rs("verifiable voting system")}
        </Paper.Text>
      </View>

      <HomeView state dispatch />

      {
      /*
      {
        switch url.path {
          | list{"election", id_str} =>
            let id = switch Belt.Int.fromString(id_str) {
              | Some(id) => id
              | None => 0
            }
            if !state.loading && state.election.id != id {
              dispatch(SetLoading(true))
              Election.get(id)
              -> Promise.thenResolve(o => {
                dispatch(LoadElectionJson(o))
                dispatch(SetLoading(false))
              })
              -> ignore
            }

            if state.loading {
              <h1>{"Loading"->rs}</h1>
            } else {
              <ElectionView state dispatch id />
            }
          | list{} =>
	      	  <HomeView state dispatch />
          | _ =>
            // TODO <NotFound />
	      	  <HomeView state dispatch />
        }
      }
      */
      <Paper.Text>{rs("")}</Paper.Text>
      }
    </View>
  </Paper.PaperProvider>
}
