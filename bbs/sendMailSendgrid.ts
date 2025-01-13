import dotenv from "dotenv";
import sgMail from "@sendgrid/mail"
dotenv.config();

export default async function(
  from: string,
  to: string,
  subject: string,
  text: string
) {
  if (process.env.SENDGRID_API_KEY) {
    sgMail.setApiKey(process.env.SENDGRID_API_KEY)
  }
  try {
    const response = await sgMail.send({
      from,
      to,
      subject,
      text
    })
    console.log("mail sent", response[0].statusCode)
  } catch(error) {
    console.error(error)
  }
}
