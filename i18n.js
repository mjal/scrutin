import i18next from 'i18next'
import { initReactI18next } from 'react-i18next'

import en from './i18n/en.json'
import fr from './i18n/fr.json'

i18next
  .use(initReactI18next)
  .init({
    debug: true,
    fallbackLng: 'en',
    resources: {
      en,
      fr
    }
  })
