module User = {
  external parse: string => User.t = "JSON.parse"
  external stringify: User.t => string = "JSON.stringify"

  let keyName = "user"

  let get = () => {
    ReactNativeAsyncStorage.getItem(keyName)
    -> Promise.thenResolve(Js.Null.toOption)
    -> Promise.thenResolve((oo) => {
      switch oo {
      | None => None
      | Some(o) => Some(parse(o))
      }
    })
  }

  let set = (o) => {
    ReactNativeAsyncStorage.setItem(keyName, stringify(o))
    -> ignore
  }

  let clean = () => {
    ReactNativeAsyncStorage.removeItem(keyName)
    -> ignore
  }
}

module Trustee = {
  external parse: string => array<Trustee.t> = "JSON.parse"
  external stringify: array<Trustee.t> => string = "JSON.stringify"

  let keyName = "trusteesKeys"

  let get = () => {
    ReactNativeAsyncStorage.getItem(keyName)
    -> Promise.thenResolve(Js.Null.toOption)
    -> Promise.thenResolve((os) => {
      switch os {
      | None => []
      | Some(s) => parse(s)
      }
    })
  }

  let set = (a) => {
    ReactNativeAsyncStorage.setItem(keyName, stringify(a))
  }

  let add = (o) => {
    Promise.then(get(), (a) => {
      set(Array.concat(a, [o]))
    }) -> ignore
  }

  let clean = () => {
    ReactNativeAsyncStorage.removeItem(keyName)
    -> ignore
  }
}

module Token = {
  external parse: string => array<Token.t> = "JSON.parse"
  external stringify: array<Token.t> => string = "JSON.stringify"

  let keyName = "tokens"

  let get = () => {
    ReactNativeAsyncStorage.getItem(keyName)
    -> Promise.thenResolve(Js.Null.toOption)
    -> Promise.thenResolve((os) => {
      switch os {
      | None => []
      | Some(s) => parse(s)
      }
    })
  }

  let set = (a) => {
    ReactNativeAsyncStorage.setItem(keyName, stringify(a))
  }

  let add = (o) => {
    Promise.then(get(), (a) => {
      set(Array.concat(a, [o]))
    }) -> ignore
  }

  let clean = () => {
    ReactNativeAsyncStorage.removeItem(keyName)
    -> ignore
  }
}