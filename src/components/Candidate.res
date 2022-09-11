open Mui; open Helper

@react.component
let make = (~name, ~dispatch) => {
  <ListItem>
    <ListItemAvatar>
      <Avatar>
        <PersonIcon />
      </Avatar>
    </ListItemAvatar>
    <ListItemText primary={name->rs} secondary={"Description"->rs} />
  </ListItem>
}
