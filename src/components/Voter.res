open Mui; open Helper

@react.component
let make = (~name, ~dispatch) => {

  let onClick = _ =>
    dispatch(State.RemoveVoter(name))

  <ListItem>
    <ListItemAvatar>
      <Avatar>
        <PersonIcon />
      </Avatar>
    </ListItemAvatar>
    <ListItemText primary=rs(name) secondary=rs("Description") />
    <IconButton onClick edge=IconButton.Edge.end>
      <DeleteIcon />
    </IconButton>
  </ListItem>
}

