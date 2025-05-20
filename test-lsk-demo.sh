#!/bin/bash

echo "============================="
echo "‚öôÔ∏è  LSK ENGINEERING DEMO START"
echo "============================="

base_url="http://localhost"

# Sample data array
declare -a orders=(
  '{"user_id":1, "product_id":101, "quantity":2}'
  '{"user_id":2, "product_id":102, "quantity":1}'
  '{"user_id":3, "product_id":103, "quantity":4}'
)

# Create orders
echo -e "\nÌªí Creating Orders..."
order_id=1
for order in "${orders[@]}"; do
  echo -e "\n‚û°Ô∏è Creating Order $order_id:"
  curl -s -X POST $base_url:5000/orders \
    -H "Content-Type: application/json" \
    -d "$order"
  ((order_id++))
done

# Submit payments
echo -e "\nÌ≤∞ Submitting Payments..."
for i in {1..3}; do
  echo -e "\n‚û°Ô∏è Paying for Order ID: $i"
  curl -s -X POST $base_url:5001/payments \
    -H "Content-Type: application/json" \
    -d "{\"order_id\":$i, \"user_id\":$i, \"amount\":${i}9.99}"
done

# Submit feedbacks
echo -e "\n‚≠ê Submitting Feedback..."
for i in {1..3}; do
  echo -e "\n‚û°Ô∏è Feedback for Order ID: $i"
  curl -s -X POST $base_url:5002/feedback \
    -H "Content-Type: application/json" \
    -d "{\"order_id\":$i, \"user_id\":$i, \"rating\":5, \"comments\":\"Great service for order $i!\"}"
done

# Retrieve orders
echo -e "\nÌ≥¶ Retrieving Orders (1st time = PostgreSQL)..."
for i in {1..3}; do
  echo -e "\n‚û°Ô∏è Order ID: $i"
  curl -s $base_url:5000/orders/$i
done

echo -e "\nÌ¥Å Retrieving Orders Again (should hit Redis cache)..."
for i in {1..3}; do
  echo -e "\n‚û°Ô∏è Order ID: $i"
  curl -s $base_url:5000/orders/$i
done

echo -e "\n‚úÖ Demo Completed Successfully"
