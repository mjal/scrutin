module State = {
  let context = React.createContext(State.initial)

  module Provider = {
    let make = React.Context.provider(context)
  }

  let use = () => React.useContext(context)
}

module Dispatch = {
  let context = React.createContext((_action: StateMsg.t) => ())

  module Provider = {
    let make = React.Context.provider(context)
  }

  let use = () => React.useContext(context)
}

let use = () => (State.use(), Dispatch.use())
