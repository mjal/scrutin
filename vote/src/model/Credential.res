type pair_t = {
  priv: BigInt.t,
  pub: string,
}

@module("sirona") @scope("Credential") @val
external generatePriv: () => (string) = "generatePriv"

@module("sirona") @scope("Credential") @val
external derive: (string, string) => pair_t = "derive"
