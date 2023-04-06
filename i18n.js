import i18next from 'i18next'
import { initReactI18next } from 'react-i18next'

i18next
  .use(initReactI18next)
  .init({
    debug: true,
    fallbackLng: 'en',
    resources: {
      en: {
        translation: {
          title: "Verifiable secret voting"
        }
      }
    }
  })
