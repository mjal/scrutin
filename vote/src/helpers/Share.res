type t = {message: string}

@module("react-native") @scope("Share") @val
external share: t => Js.Promise.t<Js.Null.t<string>> = "share"
