import dotenv from "dotenv"
import nodemailer from 'nodemailer'
dotenv.config()

const transporter = nodemailer.createTransport({
  // @ts-ignore
  pool: true,
  maxConnections: 2,
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.SMTP_ENABLE_TLS,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD,
  },
});

export default async function(
  from: string,
  to: string,
  subject: string,
  text: string
) {
  try {
    const response = await transporter.sendMail({
      from,
      to,
      subject,
      text
    })
    console.log('E-mail envoyé avec succès.', response);
  } catch(error) {
    console.error('Erreur lors de l\'envoi de l\'e-mail :', error);
  }
}

