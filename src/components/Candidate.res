open Mui
open Mui.Box

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
