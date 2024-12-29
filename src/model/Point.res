type t
type serialized_t

@module("sirona") @scope("Point") @val
external parse: serialized_t => t = "parse"

@module("sirona") @scope("Point") @val
external serialize: t => serialized_t = "serialize"
