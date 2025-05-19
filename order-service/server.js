const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'orders_db',
  password: 'password',
  port: 5432
});

app.post('/orders', async (req, res) => {
  const { user_id, product_id, quantity } = req.body;
  const result = await pool.query(
    "INSERT INTO orders (user_id, product_id, quantity) VALUES ($1, $2, $3) RETURNING *",
    [user_id, product_id, quantity]
  );
  res.json({ order: result.rows[0] });
});

app.listen(5000, () => console.log("Order service running!"));
