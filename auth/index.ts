import express from "express"
import cors from "cors"
import crypto from "crypto"
import dotenv from "dotenv"
import sgMail from "@sendgrid/mail"
import { promises as fs} from "fs"

import Knex from "knex"
import knexConfig from './knexfile'
const env = process.env.NODE_ENV || 'development'
const knex = Knex(knexConfig[env])

//const Account = require("./scrutin-lib/Account.bs.js")
//const Event_ = require("./scrutin-lib/Event_.bs.js")

import { Account, Event_ } from "./scrutin-lib"

let baseUrl = "https://demo.scrutin.app"
if (env == 'development') {
  baseUrl = "http://localhost:19006"
}

dotenv.config()

if (process.env.SENDGRID_API_KEY) {
  sgMail.setApiKey(process.env.SENDGRID_API_KEY)
}

function sendMail(email: string, electionId: string, userToken: string) {
	let link = `${baseUrl}/elections/${electionId}/challenge/${userToken}`
  if (env === 'production') {
    sgMail.send({
      from: 'Scrutin <hello@scrutin-mailing.org>',
      to: email,
      subject: "Vous êtes invité à une élection",
      text: `
        Vous êtes invité à une élection.
        Cliquez ici pour voter :
        ${link}
      `})
    .then((response) => {
      console.log("mail sent", response[0].statusCode)
    })
    .catch((error) => {
      console.error(error)
    })
  } else {
    fs.mkdir("emails", { recursive: true }).then(() => {
      fs.writeFile("emails/"+email, JSON.stringify({
        electionId,
        userToken,
        link
      })).then(() => {
        console.log("mail written to disk")
      })
    })
  }
}

const app = express()
app.use(express.json())
app.use(cors())

app.get('/', (_req, res) => {
  res.send('<h1>Hello :)</h1>')
})

app.post('/users', cors(), async (req, res) => {
  let { email, electionId, sendInvite } = req.body

  let userToken = crypto.randomBytes(16).toString('hex')
    .slice(0, 16).toUpperCase()

  let managerAccount = Account.make()
  let managerId = managerAccount.userId
  
  await knex('users').insert({
  	electionId,
  	email,
  	managerId,
  	secret: managerAccount.secret,
    userToken
  })

  if (sendInvite) {
    sendMail(email, electionId, userToken)
  }
  
  res.send({
  	electionId,
  	email,
  	managerId
  })
})

app.post('/login', async (req, res) => {
	let { email, electionId } = req.body

  const user = await knex('users').where({ email, electionId }).first();

  if (user) {
    sendMail(user.email, user.electionId, user.userToken)
  	res.send(200)
  }

  res.send(401)
})

app.post('/challenge', async (req, res) => {
  let { userId, userToken } = req.body
  const user = await knex('users').where({
    userToken
  }).first();
  if (!user) {
    return res.status(404).send({ error: 'User not found' });
  }

  const manager = Account.make2(user.secret)
  const event = Event_.ElectionDelegate.create({
    electionId: user.electionId,
    voterId: user.managerId, // = manager.userId,
    delegateId: userId
  }, manager)

  console.log(user.managerId)
  console.log(manager.userId)

  res.status(200).send(event)
  //res.status(200).send({...event, id: 0})
})

const port = process.env.PORT || 8081
app.listen(port, () => console.log(`app listening on port ${port}!`))
