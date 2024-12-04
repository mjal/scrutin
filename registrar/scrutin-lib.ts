const sjcl = require("sjcl-with-all")

export namespace Account {

  export type t = {
    userId: string,
    secret: string
  }

  export function make() : t {
    let keys = sjcl.ecc.ecdsa.generateKeys()

    let userId = keys.pub.serialize()["point"]
    let secret = keys.sec.serialize()["exponent"]

    return {
      userId,
      secret
    }
  }

  export function make2(secret: string) : t {
    let sec = sjcl.bn.fromBits(sjcl.codec.hex.toBits(secret))
    let keys = sjcl.ecc.ecdsa.generateKeys(null, null, sec)
    let userId = keys.pub.serialize()["point"]

    return {
      userId,
      secret
    }
  }

  export function signHex(account: t, hexStr: string) {
    let secretKey = new sjcl.ecc.ecdsa.secretKey(sjcl.ecc.curves.c256,
      sjcl.bn.fromBits(sjcl.codec.hex.toBits(account.secret)))
    let baEventHash = sjcl.codec.hex.toBits(hexStr)
    let baSig = secretKey.sign(baEventHash)
    return sjcl.codec.hex.fromBits(baSig)
  }

}

export namespace Event_ {

  export type t = {
    id: number,
    type_: string,
    content: string,
    cid: string,
    emitterId: string,
    signature: string,
  }

  let hash = (str: string) : string => {
    let baEventHash = sjcl.hash.sha256.hash(str)
    return sjcl.codec.hex.fromBits(baEventHash)
  }

  export function makeEvent(type_: string, content: string, account: Account.t) : t {
    let cid = hash(content)
    let emitterId = account.userId
    let signature = Account.signHex(account, cid)
    return { id: 0, type_, content, cid, emitterId, signature }
  }

  export namespace ElectionDelegate {
    export type t = { electionId: string, voterId: string, delegateId: string }

    export function create(payload: t, voter: Account.t) {
      return makeEvent("election.delegation", JSON.stringify(payload), voter)
    }
  }
}
