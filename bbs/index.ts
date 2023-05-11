import express from "express"
import cors from "cors"
import dotenv from "dotenv"

dotenv.config()
const env = process.env.NODE_ENV || 'development'

import Knex from "knex"
import knexConfig from './knexfile'
const knex = Knex(knexConfig[env])

const app = express()
app.use(express.json())
app.use(cors())

app.get('/', (_req, res) => {
  res.send('<h1>Hello :)</h1>')
})

app.get('/events', async (req, res) => {
  const { id } = req.query
  let nId = 0
  if ( typeof id === "string" )
    nId = parseInt(id)
  // Query where id is superior to nId
  const events = await knex('events').select()
  res.json(events)
})

app.post('/events', cors(), async (req, res) => {
  const { type_, content, cid, emitterId, signature } = req.body

  const item = await knex('events').insert({
    cid,
  	type_,
  	content,
  	emitterId,
    signature
  })

  res.json(item)
})

const port = process.env.PORT || 8080
app.listen(port, () => console.log(`app listening on port ${port}!`))
