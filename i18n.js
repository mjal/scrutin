import i18next from 'i18next'
import { initReactI18next } from 'react-i18next'
import * as ReactNative from "react-native";
import LanguageDetector from 'i18next-browser-languagedetector'

import en from './i18n/en.json'
import fr from './i18n/fr.json'
import nb_NO from './i18n/nb_NO.json'

let i18nextPipeline = i18next.use(initReactI18next)

if (ReactNative.Platform.OS === "web") {
  i18nextPipeline = i18nextPipeline.use(LanguageDetector)
}

i18nextPipeline.init({
  debug: true,
  fallbackLng: 'en',
  resources: {
    en,
    fr,
    nb_NO
  }
})
