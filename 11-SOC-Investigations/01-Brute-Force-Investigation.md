# SOC Investigation: Brute-Force Attack

## Scenario

A security monitoring system generated an alert after detecting multiple failed authentication attempts against a user account.

The objective of the investigation is to determine whether the activity represents a potential brute-force attack or legitimate user behavior.

## Initial Alert

The alert indicates:

- Multiple failed authentication attempts
- Same username targeted
- Repeated authentication failures
- Activity occurring within a short period

## Investigation Steps

### 1. Identify the Source

Determine the source IP address associated with the failed authentication attempts.

Questions:

- Where did the attempts originate?
- Is the source internal or external?
- Is the source system expected to access the account?

### 2. Identify the Target

Determine:

- Target username
- Target host
- Authentication service
- Number of attempts

### 3. Check for Successful Authentication

A successful login after many failed attempts is especially important.

The analyst should investigate:

- When the successful login occurred
- Source IP address
- Logon type
- User account
- Host involved

### 4. Correlate Additional Activity

After authentication, investigate whether additional suspicious activity occurred.

Examples:

- New process creation
- PowerShell execution
- Privilege assignment
- File activity
- Network connections
- Suspicious DNS queries

## Investigation Timeline

```text
Multiple Failed Logins
        ↓
Successful Authentication
        ↓
Check Source IP
        ↓
Check Logon Type
        ↓
Investigate Post-Login Activity
        ↓
Correlate Events
        ↓
Determine Verdict
