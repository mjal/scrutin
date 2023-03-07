type t = {
  electionTx: string,
  previousTx: option<string>,
  owners:     array<string>,
  ciphertext: option<string>,
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"
