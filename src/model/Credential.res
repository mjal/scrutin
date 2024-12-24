type pair_t = {
  nPrivateCredential: string,
  hPublicCredential: string,
}

@module("sirona") @scope("Credential") @val
external generatePriv: () => (string) = "generatePriv"

@module("sirona") @scope("Credential") @val
external derive: (string, string) => pair_t = "derive"
