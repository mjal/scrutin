import express from "express"
import cors from "cors"
import crypto from "crypto"
import dotenv from "dotenv"
dotenv.config()
import sgMail from "@sendgrid/mail"
import { promises as fs} from "fs"
import fetch from "cross-fetch"

import Knex from "knex"
import knexConfig from './knexfile'
const env = process.env.NODE_ENV || 'development'
const knex = Knex(knexConfig[env])

import { Account, Event_ } from "./scrutin-lib"

let baseUrl = "https://demo.scrutin.app"
if (env == 'development') {
  baseUrl = "http://localhost:19006"
}

function sendMail(email: string, electionId: string, userToken: string) {
	let link = `${baseUrl}/elections/${electionId}/token/${userToken}`
  if (env === 'production') {
    if (process.env.SENDGRID_API_KEY) {
      sgMail.setApiKey(process.env.SENDGRID_API_KEY)
    }
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

function sendSMS(phone: string, electionId: string, userToken: string) {
	let link = `${baseUrl}/elections/${electionId}/token/${userToken}`
  if (env === 'production') {
    fetch("https://mpg8q9.api.infobip.com/sms/2/text/advanced", {
      method: "POST",
      body: JSON.stringify({
        messages: [
          {
            from:"447491163443",
            destinations:[{ to: phone }],
            text: `
              Vous êtes invité à une élection.
              Cliquez ici pour voter :
              ${link}
            `
          }
        ]
      }),
      headers: {
        "Authorization": "App " + process.env.INFOBIP_API_KEY,
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => {
      console.log(data)
    })
    .catch(error => console.log(error))
  } else {
    fs.mkdir("sms", { recursive: true }).then(() => {
      fs.writeFile("sms/"+phone, JSON.stringify({
        electionId,
        userToken,
        link
      })).then(() => {
        console.log("sms written to disk")
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
  let { electionId, username, type, sendInvite } = req.body

  //let userToken = crypto.randomBytes(16).toString('hex')
  //  .slice(0, 16).toUpperCase()

  let account = Account.make()
  let userToken = account.secret
  let managerId = account.userId

  /*
  let managerAccount = Account.make()
  let managerId = managerAccount.userId
  
  await knex('users').insert({
  	electionId,
  	username,
    type,
  	managerId,
  	secret: managerAccount.secret,
    userToken
  })
  */

  if (sendInvite) {
    if (type === "email") {
      sendMail(username, electionId, userToken)
    } else if (type === "phone") {
      sendSMS(username, electionId, userToken)
    }
  }
  
  res.send({
  	electionId,
  	username,
    type,
  	managerId
  })
})

app.post('/login', async (req, res) => {
	let { username, type, electionId } = req.body

  const user = await knex('users').where({ username, type, electionId }).first();

  if (user) {
    if (user.type === "email") {
      sendMail(user.username, user.electionId, user.userToken)
    }
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
