# ==============================================================================
# AWAS A3 — Session Startup Script (Windows PowerShell)
# FIT3182 Assignment 3 | Students: 34377344 & 34076913
# ==============================================================================
# Run at the start of every session.
# Usage: .\deployment\scripts\start_session.ps1
# ==============================================================================

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  AWAS A3 - Session Startup"           -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Start containers
Write-Host ""
Write-Host "[1/3] Starting containers..." -ForegroundColor Yellow
docker start lucid_bohr zealous_shirley kafka_a2 spark_a2

Write-Host ""
Write-Host "Waiting 15s for Zookeeper/Kafka handshake..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# 2. Status check
Write-Host ""
Write-Host "[2/3] Container status:" -ForegroundColor Yellow
docker ps --format "table {{.Names}}\t{{.Status}}"

# 3. Print IPs using --format (reliable, no grep)
Write-Host ""
Write-Host "[3/3] Container IPs for this session:" -ForegroundColor Yellow
Write-Host ""

Write-Host "  zealous_shirley (MongoDB) IP:" -ForegroundColor Green
docker inspect zealous_shirley --format "    {{.NetworkSettings.IPAddress}}"

Write-Host ""
Write-Host "  kafka_a2 (Kafka) IP:" -ForegroundColor Green
docker inspect kafka_a2 --format "    {{.NetworkSettings.IPAddress}}"

Write-Host ""
Write-Host "  Your machine LAN IPv4 (HOST_IP for producer notebooks):" -ForegroundColor Green
Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.PrefixOrigin -eq "Dhcp" -or $_.PrefixOrigin -eq "Manual" } |
    Where-Object { $_.IPAddress -notmatch "^169\." } |
    Select-Object IPAddress, InterfaceAlias |
    Format-Table -AutoSize

# 4. Exact instructions per notebook
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Update these cells with the IPs above:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  A3_ml_training.ipynb         Cell 3  ->  MONGO_URI"
Write-Host "  A3_ml_streaming.ipynb        Cell 3  ->  MONGO_URI, KAFKA_BOOTSTRAP"
Write-Host "  data_design_streaming.ipynb  Section 0 (config cell) -> KAFKA_BROKER, MONGO_URI"
Write-Host "     (HOST_IP in that cell is unused — skip it)"
Write-Host "  A3_visualisation.ipynb       Cell 3  ->  HOST_IP = MongoDB IP"
Write-Host "  producer_a/b/c.ipynb         Cell 3  ->  HOST_IP = machine LAN IPv4"
Write-Host ""
Write-Host "  Jupyter:   http://localhost:8888"
Write-Host "  Spark UI:  http://localhost:4040  (while streaming runs)"
Write-Host "  Dashboard: http://localhost:8050  (after visualisation Cell 7)"
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
