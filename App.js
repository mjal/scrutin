import { make as App } from "./src/App.bs.js"
import 'react-native-get-random-values'
import './i18n'
import {
  useFonts,
  Inter_400Regular,
  Inter_700Bold,
} from '@expo-google-fonts/inter';

export default () => {
  let [fontsLoaded] = useFonts({
    Inter_400Regular,
    Inter_700Bold
  });

  return <App />;
}
