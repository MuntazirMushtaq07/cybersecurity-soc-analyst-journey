#!/bin/bash

# SOC Log Analyzer
# A simple Bash tool for searching security logs

LOG_FILE="$1"

if [ -z "$LOG_FILE" ]; then
    echo "Usage: ./log_analyzer.sh <log_file>"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found."
    exit 1
fi

echo "=================================="
echo "       SOC LOG ANALYZER"
echo "=================================="
echo "Analyzing: $LOG_FILE"
echo

echo "[+] Failed authentication attempts:"
grep -i "failed" "$LOG_FILE"

echo
echo "[+] Successful authentication attempts:"
grep -i "success" "$LOG_FILE"

echo
echo "[+] IP addresses found:"
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" | sort -u

echo
echo "=================================="
echo "Analysis complete."
