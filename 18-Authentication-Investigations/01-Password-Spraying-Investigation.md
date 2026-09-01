# SOC Investigation: Password Spraying

## Scenario

A SOC Analyst notices a large number of failed authentication attempts involving multiple user accounts.

The analyst needs to determine whether the activity could represent a password-spraying attack.

## What Is Password Spraying?

Password spraying is an authentication attack where an attacker attempts a small number of commonly used passwords against many different accounts.

The goal is to avoid triggering account lockouts while attempting to compromise one or more accounts.

## Investigation Indicators

The analyst should look for:

- Multiple usernames being targeted
- Repeated authentication failures
- Common source IP address
- Similar timestamps
- Authentication against multiple systems
- Successful login following failed attempts

## Windows Events

### Event ID 4625

Indicates a failed logon.

Multiple 4625 events involving different accounts can be an important investigation indicator.

### Event ID 4624

Indicates a successful logon.

A successful authentication following suspicious failures requires further investigation.

## Investigation Workflow

```text
Multiple Failed Logons
        ↓
Identify Source IP
        ↓
Identify Target Accounts
        ↓
Check Time Pattern
        ↓
Look for Successful Logons
        ↓
Investigate Successful Account
        ↓
Check Post-Authentication Activity
        ↓
Determine Verdict
