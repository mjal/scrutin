const express = require("express")
const app = express()
app.use(express.json())

const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize(process.env.DATABASE_URL)
const { Event, Election, Ballot, Key } = require("./src/models")(sequelize)

app.get("/", (req, res) => {
  greeting = "<h1>Hello :)</h1>";
  res.send(greeting);
});

app.post("/event", (req, res) => {
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

const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`app listening on port ${port}!`))