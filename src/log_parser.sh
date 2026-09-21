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

TARGET_LOG="${1:-samples/auth.log}"

if [ ! -f "$TARGET_LOG" ]; then
    log "Error: Target log file '${TARGET_LOG}' does not exist."
    exit 1
fi

log "Parsing log target: ${TARGET_LOG}"

# Extract failed login attempts
FAILED_LOGINS=$(grep "Failed password" "$TARGET_LOG" || true)
TOTAL_FAILED=$(echo "$FAILED_LOGINS" | grep -c . || true)

# Extract invalid username attempts
INVALID_USERS=$(grep "invalid user" "$TARGET_LOG" || true)
TOTAL_INVALID=$(echo "$INVALID_USERS" | grep -c . || true)

log "Telemetry -> Total Failed Logins: ${TOTAL_FAILED}"
log "Telemetry -> Invalid Username Probes: ${TOTAL_INVALID}"

# Extract and aggregate suspicious attacker IPs
log "Analyzing suspicious IP addresses..."
SUSPICIOUS_IPS=$(grep "Failed password" "$TARGET_LOG" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr)

echo "----------------------------------------------------------------" | tee -a "$REPORT_FILE"
echo "  ATTEMPTS | IP ADDRESS      | THREAT LEVEL" | tee -a "$REPORT_FILE"
echo "----------------------------------------------------------------" | tee -a "$REPORT_FILE"

echo "$SUSPICIOUS_IPS" | while read -r count ip; do
    if [ -n "$ip" ]; then
        if [ "$count" -ge "$ALERT_THRESHOLD" ]; then
            echo -e "     ${count}     | ${ip}  | [CRITICAL - BRUTE FORCE DETECTED]" | tee -a "$REPORT_FILE"
            log "ALERT: Automated block recommended for host ${ip} (${count} attempts)"
        else
            echo -e "     ${count}     | ${ip}  | [WARNING - LOW VOLUME]" | tee -a "$REPORT_FILE"
        fi
    fi
done

echo "----------------------------------------------------------------" | tee -a "$REPORT_FILE"
log "Security log analysis routine completed successfully."