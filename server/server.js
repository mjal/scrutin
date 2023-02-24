const express = require('express')
const { Sequelize } = require('sequelize')
const sjcl = require('sjcl-with-all')
const cors = require('cors') // TODO: Configure cors
require('dotenv').config()
const sgMail = require('@sendgrid/mail')
sgMail.setApiKey(process.env.SENDGRID_API_KEY)

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

app.post('/users', async (req, res, next) => {
  const fullName = req.body.fullName
  const email = req.body.email
  const randomWords = sjcl.random.randomWords(8)
  const secret = sjcl.codec.base32.fromBits(randomWords)
  const emailConfirmationToken = sjcl.codec.base32.fromBits(sjcl.hash.sha256.hash(randomWords))

  const user = await User.create({
    fullName,
    email,
    emailConfirmed: false,
    emailConfirmationToken
  })

  sgMail
    .send({
      to: email,
      from: 'hello@scrutin.app',
      subject: 'Votre inscription sur scrutin.app',
      text: `Veuillez confirmer votre identité en cliquant ici :
        ${process.env.CLIENT_URL}/users/email_confirmation/${secret}
      `,
      //html: '<strong>and easy to do anywhere, even with Node.js</strong>',
    })
    .then((response) => {
      console.log(response[0].statusCode)
      console.log(response[0].headers)
    })
    .catch((error) => {
      console.error(error)
    })

  res.json(user.toJSON())
})

app.post('/users/email_confirmation', async (req, res) => {
  const secret = sjcl.codec.base32.toBits(req.body.secret)
  const emailConfirmationToken = sjcl.codec.base32.fromBits(sjcl.hash.sha256.hash(secret))

  const user = await User.findOne({ where: { emailConfirmationToken } });
  if (user === null) {
    console.log('Not found!');
    res.status(404).end()
  } else {
    console.log(user instanceof User);
    console.log(user.fullName);
    res.json({ message: "Confirmation successful" }).end()
  }
})

const port = process.env.PORT || 8080
app.listen(port, () => console.log(`app listening on port ${port}!`))
