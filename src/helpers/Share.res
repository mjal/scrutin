type t = {
  message: string
}

@module("react-native") @scope("Share") @val external shate: (t) => Js.Promise.t<Js.Null.t<string>> = "share"
