#!/bin/bash
# ==============================================================================
# AWAS A3 — Kafka Topic Setup Script (Mac / Linux)
# ==============================================================================
# Creates the 3 required topics if they do not already exist.
# Safe to run multiple times — uses --if-not-exists.
#
# Usage:
#   chmod +x deployment/scripts/setup_kafka_topics.sh
#   ./deployment/scripts/setup_kafka_topics.sh
#
# Windows PowerShell equivalent (run each line manually):
#   docker exec kafka_a2 kafka-topics --bootstrap-server localhost:9092 ^
#     --create --if-not-exists --topic camera-events-A ^
#     --partitions 1 --replication-factor 1
#   docker exec kafka_a2 kafka-topics --bootstrap-server localhost:9092 ^
#     --create --if-not-exists --topic camera-events-B ^
#     --partitions 1 --replication-factor 1
#   docker exec kafka_a2 kafka-topics --bootstrap-server localhost:9092 ^
#     --create --if-not-exists --topic camera-events-C ^
#     --partitions 1 --replication-factor 1
# ==============================================================================

TOPICS=("camera-events-A" "camera-events-B" "camera-events-C")

echo ""
echo "Checking/creating Kafka topics..."
echo ""

for TOPIC in "${TOPICS[@]}"; do
    docker exec kafka_a2 kafka-topics \
        --bootstrap-server localhost:9092 \
        --create \
        --if-not-exists \
        --topic "$TOPIC" \
        --partitions 1 \
        --replication-factor 1

    echo "  [OK] $TOPIC"
done

echo ""
echo "Current topic list:"
docker exec kafka_a2 kafka-topics --bootstrap-server localhost:9092 --list
echo ""
