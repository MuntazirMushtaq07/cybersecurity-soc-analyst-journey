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



---

# Practical Investigation — SMB Authentication

## Lab Scenario

A controlled authentication test was performed against a Windows system from a Kali Linux machine to generate and investigate Windows Security authentication events.

### Lab Systems

| System     | Role              | IP             |
| ---------- | ----------------- | -------------- |
| Kali Linux | Test source       | `192.168.1.4`  |
| Windows    | Detection target  | `192.168.1.27` |
| Ubuntu     | Splunk Enterprise | `192.168.1.5`  |

## Authentication Test

The SMB service on the Windows system was tested over TCP port `445`.

A dedicated lab account named `SOC-Lab` was used.

### Failed Authentication

A deliberately incorrect password was supplied from Kali:

```bash
smbclient //192.168.1.27/IPC$ -U SOC-Lab
```

The result was:

```text
NT_STATUS_LOGON_FAILURE
```

Windows generated **Event ID 4625**.

Important evidence:

* Account: `SOC-Lab`
* Logon Type: `3` (Network)
* Workstation: `KALI`
* Source IP: `192.168.1.4`
* Failure Reason: Unknown user name or bad password
* Status: `0xC000006D`
* Sub Status: `0xC000006A`
* Authentication Package: `NTLM`

## Successful Authentication

The correct credentials were subsequently used from the same Kali system.

An SMB session was successfully established.

Windows generated **Event ID 4624**.

Important evidence:

* Account: `SOC-Lab`
* Logon Type: `3` (Network)
* Workstation: `KALI`
* Source IP: `192.168.1.4`
* Source Port: `38510`
* Authentication Package: `NTLM`
* NTLM Package: `NTLM V2`

## Splunk Investigation

Windows Security events were forwarded to Splunk Enterprise using the Splunk Universal Forwarder.

The failed authentication event was searched in Splunk using:

```spl
index=* EventCode=4625
```

The corresponding Windows Security Event 4625 was successfully identified in Splunk.

## Investigation Timeline

```text
Kali — 192.168.1.4
        |
        | SMB / TCP 445
        v
Windows — 192.168.1.27
        |
        +---- Incorrect credentials
        |          |
        |          v
        |       Event 4625
        |
        +---- Correct credentials
                   |
                   v
                Event 4624
                   |
                   v
             Splunk investigation
```

## Analyst Findings

The activity was a **controlled lab authentication test**.

The failed authentication was confirmed by Event 4625, which identified the `SOC-Lab` account, network Logon Type 3, and source IP `192.168.1.4`.

A subsequent successful network authentication using the same account and source was confirmed by Event 4624.

This demonstrates how a SOC analyst can correlate authentication events using:

* Account name
* Source IP
* Workstation
* Logon Type
* Timestamp
* Authentication package

## Evidence

### Windows Event 4625 — Failed Authentication

![Windows Event 4625](Screenshot%202026-09-25%20140558%20-%20Copy.png)

### Windows Event 4624 — Successful Authentication

![Windows Event 4624](Screenshot%202026-09-25%20151903.png)

### Splunk — Event 4625

![Splunk Event 4625](Screenshot%202026-09-25%20152131.png)

## Skills Demonstrated

* Windows Event Viewer
* Windows Security Event IDs 4624 and 4625
* SMB authentication
* Logon Type analysis
* Source IP investigation
* NTLM authentication analysis
* Splunk search
* Windows log forwarding
* Authentication event correlation
* SOC investigation and timeline construction
