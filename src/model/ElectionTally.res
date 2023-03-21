type t = {
  electionId: string,
  a: string,
  b: string,
  result: string
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
