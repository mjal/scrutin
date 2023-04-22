import { useCallback } from 'react';
import { Text } from 'react-native';
import { make as App } from "./src/App.bs.js"
import 'react-native-get-random-values'
import './i18n'
import * as SplashScreen from 'expo-splash-screen';
import {
  useFonts,
  Inter_400Regular,
  Inter_700Bold,
} from '@expo-google-fonts/inter';

// Keep the splash screen visible while we fetch resources
SplashScreen.preventAutoHideAsync();

export default () => {
  let [fontsLoaded] = useFonts({
    Inter_400Regular,
    Inter_700Bold
  });

  const onLayoutRootView = useCallback(async () => {
    if (fontsLoaded) {
      await SplashScreen.hideAsync();
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) {
    return <Text>Loading</Text>;
  } else {
    return <App />;
  }
}
