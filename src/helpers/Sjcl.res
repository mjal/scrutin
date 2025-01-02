module BitArray = {
  type t
  @module("sjcl") @scope("bitArray") @val
  external extract: (t, int, int) => int = "extract"
}

module Bn = {
  type t
  @module("sjcl") @new external new: string => t = "bn"
  @send external power: (t, int) => t = "power"
  @send external toString: t => string = "toString"
  @send external mod: (t, t) => t = "mod"
  @send external equals: (t, t) => bool = "equals"
  @send external mulmod: (t, t, t) => t = "mulmod"
  @send external powermod: (t, t, t) => t = "powermod"

  @module("sjcl") @scope("bn") @val
  external fromBits: BitArray.t => t = "fromBits"
}

module Hex = {
  @module("sjcl") @scope(("codec", "hex")) @val
  external fromBits: BitArray.t => string = "fromBits"
  @module("sjcl") @scope(("codec", "hex")) @val
  external toBits: string => BitArray.t = "toBits"
}

module Utf8String = {
  @module("sjcl") @scope(("codec", "utf8String")) @val
  external fromBits: BitArray.t => string = "fromBits"
  @module("sjcl") @scope(("codec", "utf8String")) @val
  external toBits: string => BitArray.t = "toBits"
}

module Sha256 = {
  @module("sjcl") @scope(("hash", "sha256")) @val
  external hash: string => BitArray.t = "hash"
}

module Misc = {
  @module("sjcl") @scope("misc") @val
  external pbkdf2: (string, string, int, int) => BitArray.t = "pbkdf2"
}

module Cipher = {
  type t
  @send external encrypt: (t, BitArray.t) => BitArray.t = "encrypt"
  module Aes = {
    @module("sjcl") @scope("cipher") @new external _new: BitArray.t => t = "aes"
  }
}

module Mode = {
  module CCM = {
    @module("sjcl") @scope("mode") @val
    external encrypt: (Cipher.t, BitArray.t, BitArray.t) => BitArray.t = "encrypt"
    @module("sjcl") @scope("mode") @val
    external decrypt: (Cipher.t, BitArray.t, BitArray.t) => BitArray.t = "decrypt"
  }
}

module Random = {
  @module("sjcl") @scope("random") @val
  external randomWords: int => BitArray.t = "randomWords"
  @module("sjcl") @scope("random") @val
  external addEntropy: ('a, int, string) => () = "addEntropy"
}

module Ecc = {
  module Curve = {
    type t
    @module("sjcl") @scope(("ecc", "curves")) external c192: t = "c192"
    @module("sjcl") @scope(("ecc", "curves")) external c224: t = "c224"
    @module("sjcl") @scope(("ecc", "curves")) external c256: t = "c256"
    @module("sjcl") @scope(("ecc", "curves")) external c384: t = "c384"
    @module("sjcl") @scope(("ecc", "curves")) external c521: t = "c521"
    @module("sjcl") @scope(("ecc", "curves")) external k192: t = "k192"
    @module("sjcl") @scope(("ecc", "curves")) external k224: t = "k224"
    @module("sjcl") @scope(("ecc", "curves")) external k256: t = "k256"
  }

  module Point = {
    type t
    @module("sjcl") @scope("ecc") @new external new: (Curve.t, Bn.t, Bn.t) => t = "point"
    @send external toBits: unit => BitArray.t = "toBits"
  }
}

module Ecdsa = {
  type serialized_t = {
    "type": string,
    "secretKey": bool,
    "point": string,
    "exponent": string,
    "curve": string,
  }

  module PublicKey = {
    type t

    @module("sjcl") @scope(("ecc", "ecdsa")) @new
    external new: (Ecc.Curve.t, Bn.t) => t = "publicKey"
    @module("sjcl") @scope(("ecc", "ecdsa")) @new
    external new2: (Ecc.Curve.t, Ecc.Point.t) => t = "publicKey"

    @send external verify: (t, ~hash: BitArray.t, ~signature: BitArray.t) => bool = "verify"
    @send external serialize: t => serialized_t = "serialize"

    let toHex = t => serialize(t)["point"]
    let fromHex = str => new(Ecc.Curve.c256, Bn.fromBits(Hex.toBits(str)))
  }

  module SecretKey = {
    type t

    @module("sjcl") @scope(("ecc", "ecdsa")) @new
    external new: (Ecc.Curve.t, Bn.t) => t = "secretKey"

    @send external sign: (t, BitArray.t) => BitArray.t = "sign"
    @send external serialize: t => serialized_t = "serialize"

    let toHex = t => serialize(t)["exponent"]
    let fromHex = str => new(Ecc.Curve.c256, Bn.fromBits(Hex.toBits(str)))
  }

  type t = {pub: PublicKey.t, sec: SecretKey.t}

  @module("sjcl") @scope(("ecc", "ecdsa"))
  external _generateKeys: (option<Ecc.Curve.t>, option<int>, option<Bn.t>) => t = "generateKeys"
  let generateKeys = () => _generateKeys(None, None, None)

  let generateKeysFromSecretKey = sec => _generateKeys(None, None, Some(sec))

  let new = () => {
    let keys = generateKeys()
    (keys.pub, keys.sec)
  }
}

%%raw(`
import * as Crypto from 'expo-crypto'
var ab = new Uint32Array(32);
Crypto.getRandomValues(ab)
`)
let ab = %raw(`ab`)
Random.addEntropy(ab, 1024, "expo-crypto")
