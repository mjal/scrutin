import dotenv from "dotenv";
import sgMail from "@sendgrid/mail"
import { promises as fs } from "fs"

dotenv.config();
const env = process.env.NODE_ENV || "development";

export default async function(email: string, uuid: string, token: string) {
	let link = `${process.env.BASE_URL}/elections/${uuid}/closedbooth#${token}`
  if (env === 'production') {
    if (process.env.SENDGRID_API_KEY) {
      sgMail.setApiKey(process.env.SENDGRID_API_KEY)
    }
    try {
      const response = await sgMail.send({
        from: 'Scrutin <hello@scrutin-mailing.org>',
        to: email,
        subject: "Vous êtes invité à une élection",
        text: `
          Vous êtes invité à une élection.
          Cliquez ici pour voter :
          ${link}
        `})
      console.log("mail sent", response[0].statusCode)
    } catch(error) {
      console.error(error)
    }
  } else {
    await fs.mkdir("emails", { recursive: true })
    await fs.writeFile("emails/"+email, JSON.stringify({
      uuid, token, link
    }));
    console.log("mail written to disk")
  }
}
