type i18n_t = {
  language: string,
  changeLanguage: (. string) => ()
}

type useTranslation_t = {
  t: (. string) => string,
  i18n: i18n_t
}

@module("react-i18next") @val external useTranslation: () => useTranslation_t = "useTranslation"
