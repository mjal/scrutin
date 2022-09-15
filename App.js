import { StyleSheet, View, Text } from 'react-native';

import { make as Main } from './src/Main.bs'

export default function App() {
  return (
    <View style={styles.container}>
      <Main />
      <Text>{"Hello"}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
