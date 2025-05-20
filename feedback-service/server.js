const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT
});

app.post('/feedback', async (req, res) => {
  const { order_id, user_id, rating, comments } = req.body;

  try {
    await pool.query(
      "INSERT INTO feedback (order_id, user_id, rating, comments) VALUES ($1, $2, $3, $4)",
      [order_id, user_id, rating, comments]
    );
    res.json({ message: "⭐ Feedback submitted successfully" });
  } catch (err) {
    console.error("❌ Error submitting feedback:", err);
    res.status(500).json({ error: "Failed to submit feedback" });
  }
});

app.listen(5002, () => console.log("✅ Feedback service running on port 5002"));
