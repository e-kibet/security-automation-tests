#!/bin/bash
set -e

echo "Step 1: Install dependencies..."
npm install

echo "Step 2: Run tests..."
npm run test

echo "Step 3: Start API..."
npm run start &

API_PID=$!
sleep 5  # wait for API to start

echo "Step 4: Run OWASP ZAP baseline scan..."
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t http://host.docker.internal:3000 \
  -r zap-baseline-report.html

echo "Step 5: Run OWASP ZAP full scan..."
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py \
  -t http://host.docker.internal:3000 \
  -r zap-full-report.html

echo "Step 6: Cleanup API..."
kill $API_PID

echo "✅ CI/CD pipeline complete! Reports: zap-baseline-report.html, zap-full-report.html"