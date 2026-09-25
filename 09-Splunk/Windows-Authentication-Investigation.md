# Windows Authentication Investigation — Splunk

## Objective

Performed a controlled Windows authentication investigation to understand how failed network authentication attempts generate Windows Security logs and how those logs are collected and investigated in Splunk.

## Lab Environment

| System     | Role                     | IP Address     |
| ---------- | ------------------------ | -------------- |
| Kali Linux | Test/attacker machine    | `192.168.1.4`  |
| Windows    | Detection target         | `192.168.1.27` |
| Ubuntu     | Splunk Enterprise server | `192.168.1.5`  |

## Test Scenario

A controlled SMB authentication attempt was performed from Kali Linux against the Windows system.

**Protocol:** SMB
**Port:** TCP 445
**Test account:** `SOC-Lab`

A deliberately incorrect password was entered once to generate a failed authentication event.

### Command used

```bash
smbclient //192.168.1.27/IPC$ -U SOC-Lab
```

The authentication failed with:

```text
NT_STATUS_LOGON_FAILURE
```

## Windows Detection

Windows generated:

**Event ID:** `4625` — An account failed to log on.

Important fields observed:

| Field                  | Value                             |
| ---------------------- | --------------------------------- |
| Account                | `SOC-Lab`                         |
| Account Domain         | `WORKGROUP`                       |
| Logon Type             | `3`                               |
| Failure Reason         | Unknown user name or bad password |
| Status                 | `0xC000006D`                      |
| Sub Status             | `0xC000006A`                      |
| Workstation            | `KALI`                            |
| Source IP              | `192.168.1.4`                     |
| Authentication Package | `NTLM`                            |

### SOC Interpretation

The event represents a **failed network authentication attempt**.

Logon Type `3` indicates that the authentication request was made over the network rather than through an interactive desktop logon.

The source network address identifies the originating system as the Kali machine (`192.168.1.4`).

## Splunk Investigation

The Windows Security log was forwarded to Splunk Enterprise using the Splunk Universal Forwarder.

Splunk search used:

```spl
index=* EventCode=4625
```

The corresponding Event ID `4625` was successfully received in Splunk.

The event showed:

* Windows host
* `WinEventLog:Security` source
* Event Code `4625`
* Matching timestamp
* Windows Security sourcetype

## Investigation Flow

```text
Kali Linux
192.168.1.4
     |
     | SMB authentication
     | TCP 445
     v
Windows
192.168.1.27
     |
     | Failed authentication
     v
Windows Security Event 4625
     |
     | Splunk Universal Forwarder
     v
Splunk Enterprise
192.168.1.5
     |
     v
SOC investigation
```

## Key Takeaways

* Windows Security Event `4625` can identify failed authentication attempts.
* Logon Type `3` represents network authentication.
* The source IP can help identify where the authentication attempt originated.
* SMB authentication activity can generate useful Windows Security telemetry.
* Splunk can centralize Windows Security events for investigation.
* Correlating account, source IP, timestamp, logon type and failure reason provides useful context for SOC analysis.

## Evidence

### Windows Event Viewer — Event ID 4625

The Windows Security log recorded the controlled failed network authentication attempt.

![Windows Event 4625](Screenshot%202026-09-25%20140558%20-%20Copy.png)

### Splunk — Event ID 4625

The same Windows Security event was successfully collected and displayed in Splunk.

![Splunk Event 4625](Screenshot%202026-09-25%20150432.png)


## Status

**Completed:** Controlled failed-authentication simulation and investigation in Windows Event Viewer and Splunk.

**Next investigation:** Correlate failed authentication attempts with a subsequent successful authentication event (`4624`).
