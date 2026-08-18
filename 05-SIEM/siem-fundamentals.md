# SIEM Fundamentals

## Overview

SIEM stands for Security Information and Event Management.

A SIEM collects security-related logs and events from different systems and brings them together for monitoring, detection, investigation, and incident response.

SIEM is a core technology used by SOC Analysts.

## What a SIEM Does

A SIEM can:

- Collect logs
- Centralize security events
- Search and analyze logs
- Correlate events
- Detect suspicious activity
- Generate alerts
- Support investigations
- Help create incident timelines

## Common Log Sources

A SIEM may collect logs from:

- Windows Event Logs
- Linux logs
- Firewalls
- VPNs
- DNS servers
- Web servers
- Endpoint security tools
- Network devices
- Cloud services

## Alert Investigation

A SOC Analyst should not immediately assume that every alert is malicious.

A typical investigation can follow:

```text
Alert
  ↓
Initial Triage
  ↓
Collect Evidence
  ↓
Correlate Events
  ↓
Determine Severity
  ↓
True Positive / False Positive
  ↓
Respond or Escalate
