module Bn = {
  type t
  @module("sjcl-with-all") @new external new: string => t = "bn"
  @send external power: (t, int) => t = "power"
  @send external toString: t => string = "toString"
  @send external mod: (t, t) => t = "mod"
  @send external equals: (t, t) => bool = "equals"
  @send external mulmod: (t, t, t) => t = "mulmod"
  @send external powermod: (t, t, t) => t = "powermod"
}

module BitArray = {
  type t
}

// Try using @scope("hex") and "fromBits" instead of "hex.fromBits"
module Hex = {
  @module("sjcl-with-all") @val external fromBits: BitArray.t => string = "hex.fromBits"
  @module("sjcl-with-all") @val external toBits: string => BitArray.t = "hex.toBits"
}

module Utf8String = {
  @module("sjcl-with-all") @val external fromBits: BitArray.t => string = "utf8String.fromBits"
  @module("sjcl-with-all") @val external toBits: string => BitArray.t = "utf8String.toBits"
}

module Sha256 = {
  @module("sjcl-with-all") @val external hash: string => BitArray.t = "sha256.hash"
}

module Misc = {
  @module("sjcl-with-all") @val external pbkdf2: (string, string, int, int) => BitArray.t = "misc.pbkdf2"
}

module Cipher = {
  type t
  @send external encrypt: (t, BitArray.t) => BitArray.t = "encrypt"
  module Aes = {
    @module("sjcl-with-all") @new external _new: BitArray.t => t = "cipher.aes"
  }
}

module Mode = {
  module CCM = {
    @module("sjcl-with-all") @val external encrypt: (Cipher.t, BitArray.t, BitArray.t) => BitArray.t = "mode.encrypt"
    @module("sjcl-with-all") @val external decrypt: (Cipher.t, BitArray.t, BitArray.t) => BitArray.t = "mode.decrypt"
  }
}

module Random = {
  @module("sjcl-with-all") @val external randomWords: int => BitArray.t = "random.randomWords"
}

module Ecc = {
  module Curve = {
    type t
    @module("sjcl-with-all") @scope(("ecc", "curves")) external c192 : t = "c192"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external c224 : t = "c224"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external c256 : t = "c256"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external c384 : t = "c384"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external c521 : t = "c521"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external k192 : t = "k192"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external k224 : t = "k224"
    @module("sjcl-with-all") @scope(("ecc", "curves")) external k256 : t = "k256"
  }

  module Point = {
    type t
    @module("sjcl-with-all") @scope("ecc") @new external new: (Curve.t, Bn.t, Bn.t) => t = "point"
    @send external toBits: () => BitArray.t = "toBits"
  }
}

module Ecdsa = {
  module PublicKey = {
    type t
    @send external _verify: (~hash: BitArray.t, ~signature: BitArray.t, ~fakeLegacyVersion: option<bool>) => bool = "verify"
    let verify = (~hash, ~signature) => _verify(~hash, ~signature, ~fakeLegacyVersion=None)
  }

  module SecretKey = {
    type t
    @send external _sign: (~hash: BitArray.t, ~paranoia: int, ~fakeLegacyVersion: option<bool>, ~fixedKForTesting: option<Bn.t>) => BitArray.t = "sign"
    let sign = (~hash, ~paranoia) => _sign(~hash, ~paranoia, ~fakeLegacyVersion=None, ~fixedKForTesting=None)
  }

  type t = { pub: PublicKey.t, sec: SecretKey.t }

  @module("sjcl-with-all") @scope(("ecc", "ecdsa")) external _generateKeys: (option<Ecc.Curve.t>, option<int>, option<Bn.t>) => t = "generateKeys"
  let generateKeys = () => _generateKeys(None, None, None)
}