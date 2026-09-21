#!/usr/bin/env bash

# ==========================================================
# Tool Name   : Linux Log Parser & Security Alert Script
# Description : Parses auth logs for failed SSH patterns & alerts
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_DIR="logs"
REPORT_FILE="${LOG_DIR}/security_report.log"
ALERT_THRESHOLD=3

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$REPORT_FILE"
}

log "Security Log Parser initialized."