open Mui
open Mui.Box

module Delete = {
  @react.component @module("@mui/icons-material/Delete")
  external make: unit => React.element = "default"
}

module Folder = {
  @react.component @module("@mui/icons-material/Folder")
  external make: unit => React.element = "default"
}

let rs = React.string

@react.component
let make = (~name, ~dispatch) => {

  let onClick = _ => {
    dispatch(State.RemoveVoter(name))
  }

  <ListItem
  >
    <ListItemAvatar>
      <Avatar>
        <PersonIcon />
      </Avatar>
    </ListItemAvatar>
    <ListItemText
      primary={name->rs}
      secondary={"Description"->rs}
    />
  </ListItem>
}

