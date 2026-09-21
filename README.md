# Linux Log Parser & Security Alert Tool

An automated Bash-based security auditing tool designed to inspect Linux authentication logs (`/var/log/auth.log` or custom dumps), identify suspicious brute-force login attempts, and generate threat alerts.

---

## Features

- **Failed SSH Detection:** Filters and counts total failed authentication attempts.
- **Invalid User Auditing:** Detects unauthorized username probes and brute-force patterns.
- **IP Aggregation & Ranking:** Aggregates attacker IP addresses by attempt frequency.
- **Automated Security Alerts:** Triggers critical threat warnings when failed attempts exceed defined thresholds.
- **Automated Reporting:** Generates timestamped security reports in `logs/security_report.log`.

---

## Directory Layout

```text
linux-log-parser/
├── src/
│   └── log_parser.sh       # Core parsing and alerting engine
├── samples/
│   └── auth.log            # Sample authentication log with mock attack data
├── logs/
│   └── security_report.log # Generated security telemetry report
└── README.md
```

---

## Quick Start & Usage

Make the script executable:

```bash
chmod +x src/log_parser.sh
```

Run analysis against the provided sample logs:

```bash
./src/log_parser.sh samples/auth.log
```

Run analysis against production host logs (requires read permissions):

```bash
sudo ./src/log_parser.sh /var/log/auth.log
```

---

## Sample Report Output

```text
----------------------------------------------------------------
  ATTEMPTS | IP ADDRESS      | THREAT LEVEL
----------------------------------------------------------------
     4     | 203.0.113.45    | [CRITICAL - BRUTE FORCE DETECTED]
     4     | 192.168.1.105   | [CRITICAL - BRUTE FORCE DETECTED]
----------------------------------------------------------------
```

---

## Author
**Mubeen Ali**  
DevOps & Linux Security Automation Portfolio