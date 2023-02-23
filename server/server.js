const express = require("express")
const { Sequelize, DataTypes } = require('sequelize')
const sjcl = require('sjcl-with-all')

const app = express()
app.use(express.json())

const sequelize = new Sequelize(process.env.DATABASE_URL)
const { Event, Election, Ballot, Key } = require("./src/models")(sequelize)
sequelize.sync()

app.get("/", (req, res) => {
  greeting = "<h1>Hello :)</h1>";
  res.send(greeting);
});

app.post("/events", (req, res) => {
  console.log(req.body)
  console.log(req.body.content)
  console.log(req.body.contentHash)
  console.log(req.body.publicKey)
  console.log(req.body.signature)

  let { content, contentHash, publicKey, signature } = req.body

  let event = Event.create({
    content,
    contentHash,
    publicKey,
    signature
  })

  res.json(event.toJSON())
})

app.post("/people", (req, res) => {
  let fullName = req.body.fullName
  let email = req.body.email

  let randomWords = sjcl.random.randomWords(8)
  let secret = sjcl.codec.base32.fromBits(randomWords)
  let emailConfirmationToken = sjcl.codec.base32.fromBits(sjcl.hash.sha256.hash(randomWords))
  
  let person = Person.create({
    fullName,
    email,
    emailConfirmed: false,
    emailConfirmationToken
  })

  res.json(person.toJSON())
})

const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`app listening on port ${port}!`))