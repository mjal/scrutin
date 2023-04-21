import * as Belenios from "./beleniosUninitialized"
import * as Crypto from 'expo-crypto'

var ab = new Uint32Array(32);
Crypto.getRandomValues(ab)
Belenios.belenios.sjcl.random.addEntropy(ab,
  1024, "expo-crypto")

export let {
  genTrustee,
  makeElection,
  encryptBallot,
  makeCredentials,
  derive,
  decrypt,
  result,
  demo
} = Belenios.belenios
