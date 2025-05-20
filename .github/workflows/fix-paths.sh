#!/bin/bash

cd ~/ordering-dbase/.github/workflows

# Update deploy-order.yaml
sed -i '/^  push:/,/^  branches:/ s|^      - .*|      - '\''order-service/**'\''|' deploy-order.yaml

# Update deploy-payment.yaml
sed -i '/^  push:/,/^  branches:/ s|^      - .*|      - '\''payment-service/**'\''|' deploy-payment.yaml

# Update deploy-feedback.yaml
sed -i '/^  push:/,/^  branches:/ s|^      - .*|      - '\''feedback-service/**'\''|' deploy-feedback.yaml

echo "✅ Workflow paths: filters updated successfully."
