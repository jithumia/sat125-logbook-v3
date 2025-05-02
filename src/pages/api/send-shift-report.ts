import { NextApiRequest, NextApiResponse } from 'next';
import nodemailer from 'nodemailer';

// Create a transporter using SMTP
const transporter = nodemailer.createTransport({
  host: '10.2.70.13',
  port: 25,
  secure: false, // true for 465, false for other ports
});

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  try {
    const { subject, body } = req.body;

    // Send mail
    await transporter.sendMail({
      from: 'shiftreport@mcrs3.apollo.org',
      to: 'shiftreport@mcrs3.apollo.org',
      subject,
      text: body,
    });

    res.status(200).json({ message: 'Shift report sent successfully' });
  } catch (error) {
    console.error('Error sending shift report:', error);
    res.status(500).json({ message: 'Failed to send shift report' });
  }
} 