CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    status VARCHAR(20) DEFAULT 'pending'
);

CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    order_id INT,
    user_id INT,
    rating INT,
    comments TEXT
);
