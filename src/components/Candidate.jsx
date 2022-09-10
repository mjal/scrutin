import * as React from 'react'
import { ListItem, ListItemAvatar, ListItemText, Typography, Avatar } from '@mui/material'
import DeleteIcon from '@mui/icons-material/Delete'

export default function Candidate({ name }) {
  return (
    <ListItem alignItems="flex-start">
      <ListItemAvatar>
        <Avatar alt="Travis Howard" src="2.jpg" />
      </ListItemAvatar>
      <ListItemText
        primary={name}
        secondary={
          <span>
            <Typography
              sx={{ display: 'inline' }}
              component="span"
              variant="body2"
              color="text.primary"
            >
              Quelqu un de très gentil
            </Typography>
            {" — Il y aura plus de bio à la cantine"}
						<DeleteIcon />
          </span>
        }
      />
    </ListItem>
	)
}
