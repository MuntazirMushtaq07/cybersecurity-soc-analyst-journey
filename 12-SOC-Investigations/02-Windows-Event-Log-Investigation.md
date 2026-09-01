# SOC Investigation: Windows Event Logs

## Scenario

A SOC Analyst receives an alert involving suspicious authentication activity on a Windows system.

The analyst needs to examine Windows Security Events and determine whether the activity is legitimate or potentially malicious.

## Important Event IDs

### Event ID 4624

Indicates a successful logon.

Useful investigation fields include:

- Username
- Source workstation
- Source IP address
- Logon Type
- Timestamp

### Event ID 4625

Indicates a failed logon.

Repeated failures can indicate:

- Brute-force attempts
- Password spraying
- Incorrect credentials
- Unauthorized access attempts

### Event ID 4688

Indicates that a new process was created.

This can help identify suspicious command execution or process activity.

### Event ID 4672

Indicates special privileges were assigned to a new logon.

This can be important when investigating privileged account activity.

## Investigation Workflow

```text
4625 - Failed Logons
        ↓
4624 - Successful Logon
        ↓
Check User & Source IP
        ↓
Check Logon Type
        ↓
Check 4672 Privileged Activity
        ↓
Check 4688 Process Creation
        ↓
Build Timeline
        ↓
Determine Verdict
