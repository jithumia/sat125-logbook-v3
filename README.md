# SAT.125 Logbook v3

A modern, real-time shift logbook and reporting system for SAT.125 operations, built with React, Supabase, and Node.js. Designed for seamless shift handover, data collection, and automated shift report emailing to your operations team.

## Features

- **Shift Logbook:**  
  Log all shift activities, main coil tuning, source changes, errors, downtime, and work orders in a structured, searchable format.

- **Real-Time Data Entry:**  
  Fast, user-friendly forms for all log types, with validation and grouped data entry.

- **Automated Shift Reports:**  
  Generate and email beautifully formatted shift reports to your team with a single click.

- **Role-Based Access:**  
  Secure authentication and engineer management using Supabase Auth.

- **Data Export:**  
  Export logs for analysis and compliance.

- **Responsive UI:**  
  Works on desktop and tablets, with a clean, modern interface.

## Tech Stack

- **React + Vite** – Frontend UI
- **Supabase** – Database, Auth, and Storage
- **Node.js + Express** – Email backend for shift report delivery
- **TailwindCSS** – Styling
- **TypeScript** – Type safety

## Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/jithumia/sat125-logbook-v3.git
   cd sat125-logbook-v3
   ```

2. **Install dependencies:**
   ```sh
   npm install
   ```

3. **Configure Supabase:**
   - Set your Supabase project URL and anon key in `.env`.

4. **Start the frontend:**
   ```sh
   npm run dev
   ```

5. **Start the email backend:**
   ```sh
   node server.js
   ```

6. **Visit** [http://localhost:5173](http://localhost:5173) in your browser.

## Project Structure

- `/src` – Frontend React application
- `/server.js` – Node.js backend for email sending
- `/public` – Static assets
- `/supabase` – Database migrations and config

## Development Flow

1. **Engineers log shift activities and data.**
2. **At shift end, generate and preview the shift report.**
3. **Send the report to the team via email with one click.**
4. **All logs are stored and can be exported for analysis.**

## License

MIT 
