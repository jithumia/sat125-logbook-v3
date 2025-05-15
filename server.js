import express from 'express';
import cors from 'cors';
import nodemailer from 'nodemailer';

const app = express();
app.use(cors());
app.use(express.json());

const transporter = nodemailer.createTransport({
  host: '10.2.70.13',
  port: 25,
  secure: false,
});

app.post('/send_shift_report', async (req, res) => {
  const { subject, body } = req.body;
  try {
    await transporter.sendMail({
      from: 'shiftreport@mcrs3.apollo.org',
      to: 'shiftreport@mcrs3.apollo.org', // group alias, expanded by mail server
      subject,
      text: body,
    });
    res.json({ status: 'success', message: 'Shift report sent successfully' });
  } catch (error) {
    console.error('Error sending shift report:', error);
    res.status(500).json({ status: 'error', message: 'Failed to send shift report' });
  }
});

const PORT = 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Email backend listening on port ${PORT} (all interfaces)`);
}); 