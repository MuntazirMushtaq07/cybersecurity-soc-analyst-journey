# SOC Investigation: Suspicious Process Activity

## Scenario

A SOC Analyst receives an alert indicating that an unusual process was executed on a Windows workstation.

The analyst needs to determine whether the process represents legitimate activity or potential malicious execution.

## Initial Investigation

The analyst should identify:

- Process name
- Process ID
- Parent process
- Username
- Hostname
- Command line
- Execution time
- File location

## Windows Event ID 4688

Event ID 4688 records the creation of a new process.

It can provide useful information about:

- New process
- Parent process
- Command line
- User account
- Timestamp

## Investigation Workflow

```text
Process Alert
      ↓
Identify Process
      ↓
Check File Location
      ↓
Identify Parent Process
      ↓
Examine Command Line
      ↓
Identify User
      ↓
Check Network Connections
      ↓
Correlate With Other Events
      ↓
Determine Verdict
