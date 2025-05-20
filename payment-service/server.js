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

app.post('/payments', async (req, res) => {
  const { order_id, user_id, amount } = req.body;

  // Simulate payment success
  try {
    await pool.query(
      "UPDATE orders SET status = 'paid' WHERE order_id = $1 AND user_id = $2",
      [order_id, user_id]
    );
    res.json({ message: "í²° Payment processed successfully" });
  } catch (err) {
    console.error("âŒ Payment failed:", err);
    res.status(500).json({ error: "Payment processing failed" });
  }
});

app.listen(5001, () => console.log("âœ… Payment service running on port 5001"));
