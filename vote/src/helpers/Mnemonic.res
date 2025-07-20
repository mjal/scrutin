let generate = () => {
  let words = Array.init(12, _ => {
    let index = Sjcl.BitArray.extract(Sjcl.Random.randomWords(1),0,31)
    let index = mod(index, 2048)
    Array.getExn(Wordlist.english, index)
  })
  Js.Array.joinWith(" ", words)
}

let toPrivkey = (passphrase) => {
  let words = Js.String.splitByRe(%re("/\s+/g"), String.trim(passphrase))
  let mnemonic = Js.Array.joinWith(" ", words)
  let hash = Sjcl.Sha256.hash(mnemonic)
  Zq.mod(BigInt.create("0x"++Sjcl.Hex.fromBits(hash)))
}
