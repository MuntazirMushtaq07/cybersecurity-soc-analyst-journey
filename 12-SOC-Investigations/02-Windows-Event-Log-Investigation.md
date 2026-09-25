# SOC Investigation: Windows Event Logs

## Overview

Windows Security Event Logs provide valuable information for detecting and investigating authentication activity.

In this practical investigation, I generated controlled SMB authentication activity from a Kali Linux system against a Windows system and investigated both:

* **Event ID 4625 — Failed Logon**
* **Event ID 4624 — Successful Logon**

The investigation was performed using **Windows Event Viewer** and **Splunk**.

---

## Investigation Workflow

```text
Kali Linux
    ↓
SMB Authentication
    ↓
Windows Security Logs
    ↓
4625 — Failed Authentication
    ↓
4624 — Successful Authentication
    ↓
Splunk Correlation
    ↓
Timeline Analysis
    ↓
Analyst Findings
```

---

# Lab Environment

| System     | IP Address   | Role             |
| ---------- | ------------ | ---------------- |
| Windows    | 192.168.1.27 | Detection Target |
| Kali Linux | 192.168.1.4  | Test Source      |
| Ubuntu     | 192.168.1.5  | Splunk SIEM      |

A dedicated Windows lab account named `SOC-Lab` was used for the controlled authentication tests.

---

# Investigation 1 — Failed Authentication

## Step 1 — Generate Failed SMB Authentication

From Kali Linux, an SMB connection was initiated against the Windows system:

```bash
smbclient //192.168.1.27/IPC$ -U SOC-Lab
```

An incorrect password was intentionally entered for the controlled test.

The SMB authentication failed with:

```text
NT_STATUS_LOGON_FAILURE
```

This generated a Windows Security **Event ID 4625**.

---

## Step 2 — Investigate Windows Event ID 4625

Windows Event Viewer was used to investigate the failed authentication event.

Important fields identified:

| Field                  | Observed Value                    |
| ---------------------- | --------------------------------- |
| Event ID               | 4625                              |
| Account Name           | SOC-Lab                           |
| Account Domain         | WORKGROUP                         |
| Logon Type             | 3                                 |
| Failure Reason         | Unknown user name or bad password |
| Status                 | 0xC000006D                        |
| Sub Status             | 0xC000006A                        |
| Workstation Name       | KALI                              |
| Source Network Address | 192.168.1.4                       |
| Logon Process          | NtLmSsp                           |
| Authentication Package | NTLM                              |

### Analyst Interpretation

Event ID **4625** indicates that a logon attempt failed.

The event shows that the attempt was made using the `SOC-Lab` account from the Kali system at `192.168.1.4`.

**Logon Type 3** indicates a network logon, which is consistent with the SMB authentication test.

The failure reason indicates that the supplied credentials were not accepted.

---

## Step 3 — Correlate the Failed Event in Splunk

The Windows Security logs were forwarded to Splunk using the Splunk Universal Forwarder.

The failed authentication event was searched in Splunk using:

```spl
index=* EventCode=4625
```

The corresponding Event ID 4625 was located in Splunk.

This confirmed that the Windows Security event was successfully collected and made available for SIEM investigation.

---

# Investigation 2 — Successful Authentication

## Step 4 — Generate Successful SMB Authentication

The SMB connection was attempted again using the correct password for the `SOC-Lab` account:

```bash
smbclient //192.168.1.27/IPC$ -U SOC-Lab
```

Authentication succeeded and an SMB session was established:

```text
Try "help" to get a list of possible commands.
smb: \>
```

The SMB session was then closed:

```text
exit
```

The successful authentication generated Windows Security **Event ID 4624**.

---

## Step 5 — Investigate Windows Event ID 4624

Windows Event Viewer was used to locate and investigate the corresponding successful authentication event.

Important fields identified:

| Field                  | Observed Value  |
| ---------------------- | --------------- |
| Event ID               | 4624            |
| Account Name           | SOC-Lab         |
| Account Domain         | DESKTOP-NIDUCUK |
| Logon Type             | 3               |
| Workstation Name       | KALI            |
| Source Network Address | 192.168.1.4     |
| Source Port            | 38510           |
| Logon Process          | NtLmSsp         |
| Authentication Package | NTLM            |
| NTLM Package           | NTLM V2         |
| Impersonation Level    | Impersonation   |
| Elevated Token         | No              |
| Virtual Account        | No              |
| Key Length             | 128             |

### Analyst Interpretation

Event ID **4624** indicates that Windows successfully authenticated the account.

The event shows a **network logon (Logon Type 3)** originating from the Kali system at `192.168.1.4`.

The username, source IP, workstation name, and authentication method provide useful context for determining whether the authentication was expected or suspicious.

---

## Step 6 — Correlate the Successful Event in Splunk

The successful authentication event was also collected by Splunk.

The following search can be used to locate successful logons:

```spl
index=* EventCode=4624
```

The corresponding Windows authentication activity was visible in Splunk.

This demonstrates the flow of Windows authentication telemetry from the endpoint into the SIEM.

---

# Authentication Timeline

The investigation produced the following sequence:

```text
1. Kali → Windows
   SMB authentication attempt
   ↓
2. Authentication failed
   ↓
3. Windows Event ID 4625 generated
   ↓
4. 4625 event collected by Splunk
   ↓
5. Kali → Windows
   SMB authentication attempt
   ↓
6. Authentication succeeded
   ↓
7. Windows Event ID 4624 generated
   ↓
8. 4624 event collected by Splunk
```

### Key Correlation

Both events involved:

* **User:** `SOC-Lab`
* **Source:** `192.168.1.4`
* **Workstation:** `KALI`
* **Target:** `192.168.1.27`
* **Logon Type:** `3`

This allows a SOC analyst to correlate the failed and successful authentication activity.

---

# Analyst Findings

The investigation demonstrated both failed and successful network authentication activity involving the controlled `SOC-Lab` account.

### Failed Authentication

Event ID **4625** showed that an authentication attempt from the Kali system failed because the supplied credentials were not accepted.

### Successful Authentication

Event ID **4624** showed that a subsequent authentication attempt from the same Kali system successfully authenticated the `SOC-Lab` account.

### Security Context

In this lab, both events were intentionally generated and are therefore **expected test activity**.

In a real SOC investigation, a sequence of failed authentication attempts followed by a successful authentication would require additional investigation, especially when the source IP, account, workstation, timing, or authentication method is unexpected.

Useful investigation fields include:

* Source IP address
* Username
* Timestamp
* Logon Type
* Workstation
* Authentication Package
* Number of failed attempts
* Successful authentication following failures
* Related process and network activity

---

# Evidence Screenshots

## Windows Event 4625 — Failed Authentication

![Windows Event 4625](Screenshot%202026-09-25%20150432%20-%20Copy.png)

## Splunk — Event 4625

![Splunk Event 4625](Screenshot%202026-09-25%20154926.png)

## Windows Event 4624 — Successful Authentication

![Windows Event 4624](Screenshot%202026-09-25%20151903.png)

## Splunk — Event 4624

![Splunk Event 4624](Screenshot%202026-09-25%20152131.png)

---

# Skills Demonstrated

* Windows Security Event Log analysis
* Event ID 4624 investigation
* Event ID 4625 investigation
* SMB authentication analysis
* Logon Type analysis
* Source IP identification
* Workstation identification
* NTLM authentication analysis
* Windows Event Viewer investigation
* Splunk SIEM investigation
* Log correlation
* Authentication timeline analysis
* Evidence-based SOC investigation
* Security event documentation

---

# Key Takeaways

This practical investigation demonstrated how a SOC analyst can:

1. Generate controlled authentication activity.
2. Identify failed authentication using **Event ID 4625**.
3. Identify successful authentication using **Event ID 4624**.
4. Analyze source IP, username, workstation, and logon type.
5. Correlate endpoint events with **Splunk**.
6. Build an authentication timeline.
7. Distinguish expected lab activity from activity that would require further investigation.
