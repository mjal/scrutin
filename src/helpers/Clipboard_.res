@scope(("navigator", "clipboard")) @val external writeText: (string) => Js.Promise.t<unit> = "writeText"
