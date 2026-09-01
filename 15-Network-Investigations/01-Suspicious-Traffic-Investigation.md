# SOC Investigation: Suspicious Network Traffic

## Scenario

A SOC Analyst receives an alert indicating unusual outbound network traffic from an internal workstation.

The objective is to determine whether the connection is legitimate or potentially malicious.

## Initial Investigation

The analyst should identify:

- Source IP address
- Destination IP address
- Source port
- Destination port
- Protocol
- Timestamp
- Hostname
- User
- Process responsible for the connection

## Investigation Workflow

```text
Network Alert
      ↓
Identify Source Host
      ↓
Identify Destination
      ↓
Check Protocol & Port
      ↓
Analyze Traffic
      ↓
Investigate DNS Activity
      ↓
Identify Related Process
      ↓
Correlate With SIEM Logs
      ↓
Determine Verdict
