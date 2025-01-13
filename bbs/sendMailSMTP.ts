import dotenv from "dotenv"
import nodemailer from 'nodemailer'
import { promises as fs} from "fs"

dotenv.config()
const env = process.env.NODE_ENV || "development";

const transporter = nodemailer.createTransport({
  // @ts-ignore
  pool: true,
  maxConnections: 2,
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.STMP_ENABLE_TLS,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD,
  },
});

export default async function(email: string, uuid: string, token: string) {
	let link = `${process.env.BASE_URL}/elections/${uuid}/closedbooth#${token}`
  if (1) {//env === 'production') {
    console.log("FROM");
    console.log(process.env.SMTP_FROM);
    try {
      const response = await transporter.sendMail({
        from: process.env.SMTP_FROM,
        to: email,
        subject: "Vous êtes invité·e à une élection",
        text: `
          Vous êtes invité·e à une élection.
          Cliquez ici pour voter :
          ${link}
      `})
      console.log('E-mail envoyé avec succès.', response);
    } catch(error) {
      console.error('Erreur lors de l\'envoi de l\'e-mail :', error);
    }
  } else {
    await fs.mkdir("emails", { recursive: true })
    await fs.writeFile("emails/"+email, JSON.stringify({
      uuid,
      token,
      link
    }));
    console.log("mail written to disk")
  }
}

