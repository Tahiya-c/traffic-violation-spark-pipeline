#!/bin/bash
# ==============================================================================
# AWAS A3 — Session Startup Script (Mac / Linux)
# FIT3182 Assignment 3 | Students: 34377344 & 34076913
# ==============================================================================
# Usage:
#   chmod +x deployment/scripts/start_session.sh
#   ./deployment/scripts/start_session.sh
# ==============================================================================

echo ""
echo "======================================"
echo "  AWAS A3 - Session Startup"
echo "======================================"

# 1. Start containers
echo ""
echo "[1/3] Starting containers..."
docker start lucid_bohr zealous_shirley kafka_a2 spark_a2

echo ""
echo "Waiting 15s for Zookeeper/Kafka handshake..."
sleep 15

# 2. Status
echo ""
echo "[2/3] Container status:"
docker ps --format "table {{.Names}}\t{{.Status}}"

# 3. IPs via --format flag (reliable, no grep/awk needed)
echo ""
echo "[3/3] Container IPs for this session:"
echo ""

MONGO_IP=$(docker inspect zealous_shirley --format "{{.NetworkSettings.IPAddress}}")
KAFKA_IP=$(docker inspect kafka_a2        --format "{{.NetworkSettings.IPAddress}}")

echo "  zealous_shirley (MongoDB) IP:  $MONGO_IP"
echo "  kafka_a2        (Kafka)   IP:  $KAFKA_IP"
echo ""
echo "  Your machine LAN IPv4:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null
else
    hostname -I | awk '{print "  " $1}'
fi

echo ""
echo "======================================"
echo "  Paste IPs into these notebook cells:"
echo ""
echo "  A3_ml_training.ipynb"
echo "    Cell 3 -> MONGO_URI = \"mongodb://$MONGO_IP:27017/\""
echo ""
echo "  A3_ml_streaming.ipynb"
echo "    Cell 3 -> MONGO_URI       = \"mongodb://$MONGO_IP:27017/\""
echo "    Cell 3 -> KAFKA_BOOTSTRAP = \"$KAFKA_IP:9092\""
echo ""
echo "  data_design_streaming.ipynb"
echo "    Section 0 config cell -> KAFKA_BROKER = \"$KAFKA_IP:9092\""
echo "    Section 0 config cell -> MONGO_URI    = \"mongodb://$MONGO_IP:27017/\""
echo "    (HOST_IP in that cell is defined but unused — skip it)"
echo ""
echo "  A3_visualisation.ipynb"
echo "    Cell 3 -> HOST_IP = \"$MONGO_IP\"  (MongoDB IP, not LAN)"
echo ""
echo "  producer_a/b/c.ipynb"
echo "    Cell 3 -> HOST_IP = <machine LAN IPv4 printed above>"
echo ""
echo "  Jupyter:   http://localhost:8888"
echo "  Spark UI:  http://localhost:4040"
echo "  Dashboard: http://localhost:8050"
echo "======================================"
echo ""
