# SOC Investigation: Suspicious PowerShell Activity

## Scenario

A SOC Analyst receives an alert involving suspicious PowerShell activity on a Windows workstation.

The objective is to determine whether the PowerShell execution was legitimate administrative activity or potentially malicious.

## Initial Investigation

The analyst should identify:

- Username
- Hostname
- Source IP
- Process name
- Parent process
- Command line
- Timestamp
- PowerShell execution details

## Important Windows Event

### Event ID 4688

Event ID 4688 records the creation of a new process.

It can provide useful information about:

- Process name
- Command line
- Parent process
- User account
- Time of execution

## Investigation Workflow

```text
PowerShell Alert
      ↓
Identify User
      ↓
Identify Host
      ↓
Examine Command Line
      ↓
Check Parent Process
      ↓
Check Previous & Subsequent Events
      ↓
Correlate Network Activity
      ↓
Determine Verdict
