const express = require('express')
const { Sequelize } = require('sequelize')
const sjcl = require('sjcl-with-all')
const cors = require('cors') // TODO: Configure cors
require('dotenv').config()

const app = express()
app.use(express.json())
app.use(cors())

const sequelize = new Sequelize(process.env.DATABASE_URL)
const { Event_, Election, Ballot, User, Key } = require('./src/models')(sequelize)
sequelize.sync()

app.get('/', (req, res) => {
  const greeting = '<h1>Hello :)</h1>'
  res.send(greeting)
})

app.post('/events', (req, res) => {
  console.log(req.body)
  console.log(req.body.content)
  console.log(req.body.contentHash)
  console.log(req.body.publicKey)
  console.log(req.body.signature)
  const { content, contentHash, publicKey, signature } = req.body
  const event = Event_.create({
    content,
    contentHash,
    publicKey,
    signature
  })
  res.json(event.toJSON())
})

app.post('/users', cors(), (req, res) => {
  const fullName = req.body.fullName
  const email = req.body.email
  const randomWords = sjcl.random.randomWords(8)
  const secret = sjcl.codec.base32.fromBits(randomWords)
  const emailConfirmationToken = sjcl.codec.base32.fromBits(sjcl.hash.sha256.hash(randomWords))
  const user = User.create({
    fullName,
    email,
    emailConfirmed: false,
    emailConfirmationToken
  })
  res.json(user.toJSON())
})

const port = process.env.PORT || 8080
app.listen(port, () => console.log(`app listening on port ${port}!`))
