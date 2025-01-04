@module("expo-file-system")
external documentDirectory: string = "documentDirectory"

@module("expo-file-system")
external writeAsStringAsync: (string, string) => Js.Promise.t<unit> = "writeAsStringAsync"
