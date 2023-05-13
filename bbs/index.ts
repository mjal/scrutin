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
  const { from } = req.query
  let nId = 0
  if ( typeof from === "string" )
    nId = parseInt(from)
  const events = await knex('events').select()
    .where('id', '>', nId).orderBy('id')
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
