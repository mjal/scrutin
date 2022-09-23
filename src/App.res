open Helper
open ReactNative;
open Paper;

let styles = {
  open Style
  StyleSheet.create({
    "container": viewStyle(~flex=1.,()),
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
	  <SafeAreaView style=styles["container"]>
      <ScrollView>
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

        {
          switch state.view {
            | Home => <HomeView state dispatch />
            | FetchingElection(id) => "Fetching election..."->rs
            | Election(id) => <ElectionView state dispatch id />
          }
        }
        {
        /*
        Election.get(id)
        -> Promise.thenResolve(o => {
          dispatch(LoadElectionJson(o))
          dispatch(SetLoading(false))
        })
        -> ignore
        */""->rs
        }
      </ScrollView>
    </SafeAreaView>
  </Paper.PaperProvider>
}
