type t = {
  params:   string,
  trustees: string,
  ownerPublicKey: string
}

external parse:           string => t = "JSON.parse"
external stringify:       t => string = "JSON.stringify"

let make = (name, description, choices, ownerPublicKey) => {
  let (privkey, trustees) = Belenios.Trustees.create()
  Store.Trustee.add({pubkey: Belenios.Trustees.pubkey(trustees), privkey})

  let params =
    Belenios.Election._create(~name, ~description, ~choices, ~trustees)

  {
    params,
    trustees: Belenios.Trustees.to_str(trustees),
    ownerPublicKey
  }
}
