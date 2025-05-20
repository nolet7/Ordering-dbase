#!/bin/bash

echo "==> Starting LSK environment..."
docker-compose down -v
docker-compose up -d --build

echo "==> Waiting for services to start..."
sleep 10

echo "==> Running tests and logging output to demo-output.log"
bash ~/ordering-dbase/test-lsk-demo.sh | tee ~/ordering-dbase/demo-output.log
