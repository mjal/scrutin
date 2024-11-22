import { Text, View } from "react-native";

import { make as App } from "./App.bs.js"

import './i18n'

export default function Index() {
  return <App />
  //return (
  //  <View
  //    style={{
  //      flex: 1,
  //      justifyContent: "center",
  //      alignItems: "center",
  //    }}
  //  >
  //    <Text>Edit app/index.tsx to edit this screen.</Text>
  //  </View>
  //);
}
