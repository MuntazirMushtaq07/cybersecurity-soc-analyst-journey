# End-to-End SOC Investigation

## Scenario

A SOC Analyst receives a security alert involving suspicious authentication activity on a Windows workstation.

The objective is to investigate the complete sequence of events and determine whether the activity represents a legitimate action or a potential security incident.

## Initial Alert

The investigation begins with an alert indicating unusual authentication activity.

The analyst collects:

- Username
- Hostname
- Source IP
- Destination IP
- Timestamp
- Event IDs
- Process information
- DNS activity
- Network activity

## Investigation Timeline

The analyst builds a timeline by correlating events from different sources.

Example:

```text
Multiple Failed Logins
        ↓
Successful Login
        ↓
Privileged Activity
        ↓
PowerShell Execution
        ↓
Suspicious DNS Query
        ↓
Outbound Network Connection
        ↓
Further Investigation
