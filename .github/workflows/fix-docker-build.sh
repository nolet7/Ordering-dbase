#!/bin/bash

echo "í´§ Updating GitHub Actions workflows for proper Docker builds..."

cd ~/ordering-dbase/.github/workflows

# Order Service
cat << 'YAML' > deploy-order.yaml
name: Build & Push Order Service

on:
  push:
    paths:
      - 'order-service/**'
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Log in to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and Push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./order-service
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/order-service:latest
YAML

# Payment Service
cat << 'YAML' > deploy-payment.yaml
name: Build & Push Payment Service

on:
  push:
    paths:
      - 'payment-service/**'
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Log in to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and Push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./payment-service
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/payment-service:latest
YAML

# Feedback Service
cat << 'YAML' > deploy-feedback.yaml
name: Build & Push Feedback Service

on:
  push:
    paths:
      - 'feedback-service/**'
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Log in to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and Push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./feedback-service
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/feedback-service:latest
YAML

echo "âœ… Workflow files updated."

cd ~/ordering-dbase
git add .github/workflows
git commit -m "Fix: use buildx for Docker image builds in GitHub Actions"
git push origin main

echo "íº€ Pushed to GitHub â€” go to https://github.com/nolet7/Ordering-dbase/actions to confirm workflows."
