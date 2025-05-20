const express = require('express');
const { Pool } = require('pg');
const { createClient } = require('redis');

const app = express();
app.use(express.json());

// PostgreSQL client setup
const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
});

// Redis client setup
const redisClient = createClient({ url: 'redis://redis:6379' });

redisClient.on('error', (err) => {
  console.error('❌ Redis Client Error:', err);
});

(async () => {
  await redisClient.connect();
  console.log('✅ Connected to Redis');
})();

// Create a new order
app.post('/orders', async (req, res) => {
  try {
    const { user_id, product_id, quantity } = req.body;

    const result = await pool.query(
      "INSERT INTO orders (user_id, product_id, quantity) VALUES ($1, $2, $3) RETURNING *",
      [user_id, product_id, quantity]
    );

    // Invalidate any existing cache for this order ID (just in case)
    const orderId = result.rows[0].order_id;
    await redisClient.del(`order:${orderId}`);

    res.json({ order: result.rows[0], source: 'postgres' });
  } catch (err) {
    console.error('❌ Error inserting order:', err);
    res.status(500).json({ error: 'Failed to create order' });
  }
});

// Get an order by ID (with Redis caching)
app.get('/orders/:id', async (req, res) => {
  const orderId = req.params.id;

  try {
    // Check Redis cache first
    const cachedOrder = await redisClient.get(`order:${orderId}`);

    if (cachedOrder) {
      return res.json({ order: JSON.parse(cachedOrder), source: 'cache' });
    }

    // Fetch from PostgreSQL
    const result = await pool.query("SELECT * FROM orders WHERE order_id = $1", [orderId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }

    const order = result.rows[0];

    // Cache the order in Redis (with a 60s TTL)
    await redisClient.set(`order:${orderId}`, JSON.stringify(order), { EX: 60 });

    res.json({ order, source: 'postgres' });
  } catch (err) {
    console.error('❌ Error fetching order:', err);
    res.status(500).json({ error: 'Failed to fetch order' });
  }
});

// Start server
app.listen(5000, () => {
  console.log('✅ Order service with Redis caching running on port 5000');
});
