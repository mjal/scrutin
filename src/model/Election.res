type t = {
  version: int,
  description: string,
  name: string,
  group: string,
  public_key: Point.t,
  questions: array<QuestionH.t>,
  uuid: string,
  administrator?: string,
  credential_authority?: string,
  unrestricted?: bool
}
type serialized_t

  @module("sirona") @scope("Election") @val
  external create: (string, string, array<Trustee.t>, array<QuestionH.t>) => t = "create"

  external toJSON : t => Js.Json.t = "%identity"
  external toJSONs : serialized_t => Js.Json.t = "%identity"

  external fromJSON : Js.Json.t => t = "JSON.parse"
  external fromJSONs : Js.Json.t => serialized_t = "JSON.parse"

  @module("sirona") @scope("Election") @val
  external parse: serialized_t => t = "parse"

  @module("sirona") @scope("Election") @val
  external serialize: t => serialized_t = "serialize"
