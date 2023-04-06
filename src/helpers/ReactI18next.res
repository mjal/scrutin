type useTranslation_t = {
  t: (. string) => string
}

@module("react-i18next") @val external useTranslation: () => useTranslation_t = "useTranslation"
