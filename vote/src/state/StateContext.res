module State = {
  let context = React.createContext(State.initial)

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }

  let use = () => React.useContext(context)
}

module Dispatch = {
  let context = React.createContext((_action: StateMsg.t) => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }

  let use = () => React.useContext(context)
}

let use = () => (State.use(), Dispatch.use())
