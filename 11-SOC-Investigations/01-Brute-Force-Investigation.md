# Windows Brute-Force Attack Detection & SOC Investigation

## Overview

This project demonstrates a controlled SOC investigation of a simulated Windows password-guessing/brute-force attack.

The objective was to generate realistic authentication telemetry from a Kali Linux test machine against a Windows system, collect the resulting Windows Security events through Splunk, identify repeated failed authentication attempts, investigate a subsequent successful authentication, and examine activity performed after authentication.

The investigation follows a simplified real-world SOC workflow:

**Reconnaissance → Authentication Attempts → Log Collection → Detection → Investigation → Timeline Reconstruction → Post-Authentication Analysis**

---

## Objective

The objectives of this investigation were to:

* Identify an exposed authentication service on a Windows host.
* Generate controlled failed authentication attempts.
* Observe Windows Event ID 4625 authentication failures.
* Verify that the events were ingested into Splunk.
* Identify a repeated failed-login pattern.
* Investigate a subsequent Event ID 4624 successful authentication.
* Determine the privileges of the authenticated account.
* Investigate post-authentication process activity using Event ID 4688.
* Build a basic Splunk detection based on repeated authentication failures.
* Document the investigation as a SOC analyst would.

---

## Lab Environment

| Component               | Details                    |
| ----------------------- | -------------------------- |
| Attack/Test Machine     | Kali Linux                 |
| Attack Source IP        | 192.168.1.4                |
| Windows Target          | Windows                    |
| Windows Target IP       | 192.168.1.27               |
| Tested Account          | SOC-Lab                    |
| SIEM                    | Splunk Enterprise          |
| Log Collection          | Splunk Universal Forwarder |
| Authentication Protocol | SMB                        |
| Relevant Windows Events | 4625, 4624, 4688           |

---

## Attack / Investigation Flow

```text
Kali Linux
    |
    | SMB authentication attempts
    v
Windows Target
    |
    +---- 4625 Failed Authentication
    |
    +---- 4625 Failed Authentication
    |
    +---- 4625 Failed Authentication
    |
    +---- Multiple Failed Attempts
    |
    +---- 4624 Successful Authentication
    |
    v
SOC-Lab Account
    |
    +---- Account privilege investigation
    |
    +---- 4688 Process Creation
    |
    v
Splunk Investigation
    |
    v
Detection + Timeline Reconstruction
```

---

# 1. Reconnaissance

Nmap was used to identify services exposed by the Windows target.

Command used:

```bash
nmap -Pn -sV 192.168.1.27
```

The initial reconnaissance identified the Windows host and its available services. SMB was subsequently made temporarily accessible from the Kali test machine for the controlled authentication experiment.

The SMB firewall rule was restricted to the Kali test machine rather than exposing SMB generally.

---

# 2. Controlled Authentication Testing

A local Windows account named `SOC-Lab` was used for the controlled authentication test.

Multiple intentionally incorrect passwords were submitted from the Kali test machine, followed by the correct password.

This generated repeated Windows authentication failures followed by a successful authentication.

The activity was performed only against the user's own lab environment.

---

# 3. Windows Event ID 4625 — Failed Authentication

Windows Security Event ID **4625** records a failed account logon.

The generated events were forwarded to Splunk through the Windows Splunk Universal Forwarder.

The investigation identified repeated 4625 events associated with the authentication testing.

The Splunk results were reviewed and sorted by time to reconstruct the authentication activity.

**Evidence 1** — Splunk 4625 authentication events showing the failed-login activity.

**Evidence 2** — Splunk 4625 events displayed in a time-sorted table for investigation.

---

# 4. Windows Event ID 4624 — Successful Authentication

After the repeated failed authentication attempts, a successful authentication was generated.

Windows Event ID **4624** records a successful account logon.

The corresponding 4624 event was also forwarded to Splunk.

The successful authentication was investigated together with the preceding failed authentication activity rather than being treated as an isolated event.

**Evidence 3** — Splunk 4624 successful authentication event.

**Evidence 4** — Time-sorted authentication results showing the 4624 activity in relation to the authentication events.

---

# 5. Brute-Force / Password-Guessing Detection

A basic threshold-based detection was tested in Splunk.

Example SPL:

```spl
index=* EventCode=4625
| bin _time span=5m
| stats count as failed_attempts
```

The controlled test produced repeated failed authentication events within the observed time window.

The investigation recorded **19 Event ID 4625 failures** during the testing period.

A threshold of **5 or more failures within a 5-minute window** was used as the laboratory detection threshold.

The purpose of the threshold was to demonstrate how repeated authentication failures can be identified automatically rather than investigated individually.

Important distinction:

Because this was a controlled lab experiment, the activity can accurately be described as a **simulated brute-force/password-guessing attack**.

In a real SOC environment, repeated 4625 events followed by a 4624 would be investigated as activity **consistent with password guessing**, while additional context would be required to determine intent.

---

# 6. Authentication Timeline

The authentication events were sorted chronologically in Splunk.

The resulting timeline allowed the investigation to establish the sequence of:

```text
Multiple 4625 failures
        ↓
Successful 4624 authentication
        ↓
Authenticated SOC-Lab session
        ↓
Post-authentication activity
```

**Evidence 5** — Splunk authentication timeline showing Event IDs and timestamps.

This timeline was used as the primary evidence for reconstructing the simulated authentication attack.

---

# 7. Account Privilege Investigation

The `SOC-Lab` account was investigated after successful authentication.

The account was verified using:

```cmd
whoami
```

and:

```cmd
whoami /groups
```

The account was found to belong to the standard:

```text
BUILTIN\Users
```

group and was **not** a member of the local Administrators group.

The session also showed:

```text
Medium Mandatory Level
```

This demonstrated that the successful password authentication did **not** result in administrator privileges.

---

# 8. Post-Authentication Process Investigation

Windows process-creation auditing was enabled for Event ID **4688**.

A controlled Notepad process was then launched from the authenticated `SOC-Lab` context.

Windows generated a 4688 event showing:

* Creator Account: `SOC-Lab`
* Creator Process: `cmd.exe`
* New Process: `Notepad.exe`
* Mandatory Label: `Medium Mandatory Level`

This demonstrated how a SOC analyst can investigate activity occurring after a successful authentication.

**Evidence 6** — Windows Event ID 4688 showing `SOC-Lab` creating the Notepad process.

The 4688 event is **not itself proof of brute force**. Instead, it provides post-authentication context for the investigation.

---

# 9. SOC Investigation Assessment

The controlled investigation produced the following sequence:

1. Kali Linux performed reconnaissance against the Windows target.
2. SMB authentication was made available only for the controlled test.
3. Multiple incorrect authentication attempts were generated against `SOC-Lab`.
4. Windows recorded repeated Event ID 4625 failures.
5. Splunk successfully received and displayed the authentication events.
6. A successful Event ID 4624 authentication was subsequently observed.
7. The authenticated account was verified as `SOC-Lab`.
8. The account was confirmed to be a standard user rather than an administrator.
9. Windows Event ID 4688 recorded post-authentication process creation.
10. The resulting evidence was reviewed through Splunk and Windows Event Viewer.

### Investigation Conclusion

The laboratory evidence demonstrates a **simulated password-guessing/brute-force scenario** in which repeated failed authentication attempts were followed by a successful authentication.

The investigation also demonstrated the importance of looking beyond the initial authentication alert. After the successful login, the account and subsequent process activity were investigated to determine what access had actually been obtained and what activity occurred afterward.

No evidence from this controlled test demonstrated that the `SOC-Lab` account obtained administrator privileges.

---

# 10. Detection Logic

The basic detection concept used in this project was:

```text
Multiple failed authentication events
                +
Short time window
                +
Same authentication target
                ↓
       Investigate for
    password guessing
```

A practical SOC implementation could additionally correlate:

* Source IP
* Target account
* Number of failures
* Time window
* Successful authentication
* Logon type
* Workstation
* Geographic/network context
* Subsequent process activity

This project demonstrates the foundational version of that workflow using Windows Security logs and Splunk.

---

# 11. Tools Used

* Kali Linux
* Nmap
* SMB / smbclient
* Windows Event Viewer
* Windows Security Event Logs
* Splunk Enterprise
* Splunk Universal Forwarder
* Splunk SPL

---

# 12. Skills Demonstrated

### Windows Security Monitoring

* Event ID 4625 analysis
* Event ID 4624 analysis
* Event ID 4688 analysis
* Authentication investigation
* Process creation investigation
* Account privilege analysis

### SIEM / Splunk

* Windows log ingestion
* Splunk Search & Reporting
* SPL filtering
* Event counting
* Time-based event grouping
* Threshold-based detection
* Authentication timeline reconstruction

### SOC Investigation

* Attack-source identification
* Authentication pattern analysis
* Detection development
* Alert investigation methodology
* Post-authentication investigation
* Evidence collection
* Incident timeline development
* Distinguishing authentication from privilege escalation

---

# 13. Evidence

The investigation evidence is included with this project using the following references:

## Evidence

### Evidence 1 — 

![Evidence 1](./Screenshot%202026-09-25%20164214.png)

### Evidence 2 — 

![Evidence 2](./Screenshot%202026-09-25%20164316.png)

### Evidence 3 — 

![Evidence 3](./Screenshot%202026-09-25%20185529.png)

### Evidence 4 — 

![Evidence 4](./Screenshot%202026-09-25%20190817.png)

### Evidence 5 — 

![Evidence 5](./Screenshot%202026-09-25%20191028.png)

### Evidence 6 — 

![Evidence 6](./Screenshot%202026-09-25%20192656.png)

### Evidence 7 — 

![Evidence 7](./Screenshot%202026-09-25%20193807.png)


The evidence consists only of telemetry generated during the controlled laboratory investigation.

---

# 14. Key Takeaway

This project demonstrates a complete entry-level SOC investigation rather than simply running an offensive-security tool.

The key workflow was:

**Generate → Collect → Detect → Investigate → Correlate → Document**

The project demonstrates how Windows authentication telemetry can be transformed into an investigation using a SIEM and how post-authentication activity can provide additional context after an authentication alert.
