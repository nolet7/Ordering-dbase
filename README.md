#  LSK Engineering Ordering System

A production-grade microservices demo application built using:

- **Node.js + Express** (for Order, Payment, and Feedback services)
- **PostgreSQL** with **StatefulSet** (for order data persistence)
- **Redis** (for caching orders)
- **Kubernetes** (with HPA for auto-scaling)
- **Docker + GitHub Actions** (for CI/CD)
- **HashiCorp Vault** (optional: for managing secrets)

---

## Microservices Overview

| Service            | Port | Description                             |
|--------------------|------|-----------------------------------------|
| `order-service`     | 5000 | Create and fetch orders (Redis caching) |
| `payment-service`   | 5001 | Process payments (updates PostgreSQL)   |
| `feedback-service`  | 5002 | Submit & fetch feedback for orders      |
| `postgres-db`       | 5432 | Stores orders and feedback (via PV)     |
| `redis`             | 6379 | Caches order queries                    |

---

## Quick Start

###  1. Run with Docker Compose (Local Dev)

```bash
docker-compose down -v
docker-compose up -d --build
Access services:

Order: http://localhost:5000/orders/1

Payment: http://localhost:5001/payments

Feedback: http://localhost:5002/feedback/1

βΈοΈ 2. Deploy to Kubernetes (Production)
Create the PostgreSQL persistent volume and StatefulSet:
kubectl apply -f postgres-db/k8s/local-storage.yaml
kubectl apply -f postgres-db/k8s/postgres-pv.yaml
kubectl apply -f postgres-db/k8s/statefulset.yaml

Deploy Redis:

bash
Copy
Edit
kubectl apply -f redis/k8s/
Deploy microservices:

bash
Copy
Edit
kubectl apply -f order-service/k8s/
kubectl apply -f payment-service/k8s/
kubectl apply -f feedback-service/k8s/
Check exposed ports (e.g.):

bash
Copy
Edit
kubectl get svc
Then access:

Order: curl http://<NODE-IP>:30080/orders/1

Payment: curl -X POST http://<NODE-IP>:30081/payments

Feedback: curl http://<NODE-IP>:30082/feedback/1

ν΄ Environment Variables
Each service expects the following environment variables in Kubernetes:

env
Copy
Edit
PGUSER=postgres
PGPASSWORD=password
PGHOST=postgres
PGPORT=5432
PGDATABASE=orders_db

Set these in each deployment file or inject via HashiCorp Vault.

Architecture Diagram
                                 ββββββββββββββββ
                                 β   Clients    β
                                 βββββββ¬βββββββββ
                                       β
           βββββββββββββββββββββββββββββΌβββββββββββββββββββββββββββββ
           β                           β                            β
  ββββββββββΌβββββββββ        βββββββββββΌβββββββββ         βββββββββββΌβββββββββ
  β  order-service  β        β payment-service  β         β feedback-service β
  ββββββββ¬βββββββββββ        ββββββββββ¬ββββββββββ         ββββββββββ¬ββββββββββ
         β                             β                            β
         β                             β                            β
         βΌ                             βΌ                            βΌ
   ββββββββββββββ              ββββββββββββββ              ββββββββββββββ
   β   Redis    β              β PostgreSQL ββββββββββββββββ            β
   ββββββββββββββ              β  Stateful  β<ββββfeedback & ordersβββββββ
                              β     Set     β
                              βββββββββββββββ

CI/CD & GitHub Actions

Each service has its own workflow under:

bash
Copy
Edit
.github/workflows/deploy-*.yaml
They build Docker images and push to Docker Hub automatically on main changes.


Health Check Endpoints
GET / β Health check for each service

GET /orders/:id β Fetch order (cached)

POST /payments β Mark order as paid

GET /feedback/:order_id β View feedback

POST /feedback β Submit new feedback

