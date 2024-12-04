import express from "express";
import cors from "cors"
import crypto from "crypto"
import dotenv from "dotenv"
dotenv.config()
import sgMail from "@sendgrid/mail"
import { promises as fs} from "fs"
import { Account, Event_ } from "./scrutin-lib"

const env = process.env.NODE_ENV || 'development'

let baseUrl = "https:/staging.scrutin.app"
if (env == 'development') {
  baseUrl = "http://localhost:19006"
}

function sendMail(email: string, uuid: string, userToken: string) {
	let link = `${baseUrl}/elections/${uuid}/booth#${userToken}`
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
        uuid,
        userToken,
        link
      })).then(() => {
        console.log("mail written to disk")
      })
    })
  }
}

const app = express();
app.use(express.json());
app.use(cors());

app.get("/", (_req, res) => {
  res.send("<h1>Hello o/</h1>");
});

// Endpoint to send keys
app.post("/send-keys", async (req, res) => {
  const { uuid, emails } = req.body;

  if (!Array.isArray(emails)) {
    return res.status(400).send({ error: "Invalid input. Provide a list of emails." });
  }

  const keys = emails.map((email) => {

    let account = Account.make()
    let { userId, secret } = account

    sendMail(email, uuid, secret);
    return { email, credential: userId };
  });

  res.status(200).send(keys);
});

const port = process.env.PORT || 8081;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
