# Windows Attack Chain Detection & Incident Response

## Project Overview

This project demonstrates a controlled Windows security incident from **attack simulation through incident response and recovery**.

The goal was to build and investigate a realistic SOC workflow using a Windows endpoint and Splunk SIEM.

The project covered:

**Attack Simulation → Windows Telemetry → Splunk Collection → Detection → Investigation → Containment → Eradication → Recovery**

All activities were performed in a controlled personal lab environment using harmless test actions. No real malware was used.

---

## Objectives

* Generate realistic Windows security telemetry
* Collect Windows events in Splunk
* Detect suspicious PowerShell execution
* Investigate Windows process and authentication events
* Build an incident timeline
* Simulate persistence using a scheduled task
* Perform containment
* Perform eradication
* Perform recovery
* Document the incident like a SOC analyst

---

## Lab Architecture

| Component       | Role                            | IP Address     |
| --------------- | ------------------------------- | -------------- |
| Kali Linux      | Controlled test/attacker system | `192.168.1.4`  |
| Windows         | Monitored endpoint              | `192.168.1.27` |
| Ubuntu + Splunk | SIEM                            | `192.168.1.5`  |

### Data Flow

```text
Kali / Test Activity
        ↓
Windows Endpoint
        ↓
Windows Event Logs
        ↓
Splunk Universal Forwarder
        ↓
Splunk Enterprise
        ↓
Detection & Investigation
        ↓
Incident Response
```

---

# 1. Attack Simulation

The project used controlled and harmless simulations rather than real malware.

The simulated attack chain included:

1. SMB reconnaissance
2. Authentication attempts
3. Successful SMB authentication
4. PowerShell process execution
5. PowerShell Script Block Logging
6. Network connection testing
7. Scheduled-task persistence simulation

The purpose was to generate telemetry that a SOC analyst could investigate.

---

# 2. Initial Reconnaissance

The Windows endpoint was scanned from Kali using:

```bash
nmap -Pn -sV 192.168.1.27
```

The scan identified Windows services including:

* TCP 135 — Microsoft RPC
* TCP 139 — NetBIOS
* TCP 445 — SMB
* TCP 3306 — MySQL/MariaDB

SMB port 445 was used for the controlled authentication portion of the lab.

---

# 3. Windows Authentication Investigation

Windows Security Event IDs were investigated in Splunk.

### Event ID 4625 — Failed Logon

The lab generated failed authentication attempts against the `SOC-Lab` account.

The investigation focused on:

* Source IP
* Username
* Logon Type
* Failure information
* Event timestamps
* Frequency of failed attempts

The activity demonstrated how repeated authentication failures can provide an initial indicator for a SOC investigation.

### Event ID 4624 — Successful Logon

A successful SMB authentication followed the failed attempts.

The investigation correlated:

```text
4625 Failed Authentication
        ↓
4625 Failed Authentication
        ↓
4625 Failed Authentication
        ↓
4624 Successful Authentication
```

This sequence demonstrated why SOC analysts should investigate authentication events as a timeline rather than viewing individual events in isolation.

---

# 4. Process Creation Monitoring

Windows Process Creation auditing was enabled to generate Event ID **4688** telemetry.

The Splunk detection search used:

```spl
index=* EventCode=4688 "powershell.exe"
```

This successfully identified PowerShell process creation events.

The investigation examined the relationship between:

* Process creation
* User account
* Host
* Timestamp
* PowerShell activity

---

# 5. PowerShell Script Block Logging

PowerShell Script Block Logging was enabled using Windows registry policy configuration.

The lab generated harmless PowerShell activity.

Example test:

```cmd
powershell.exe -Command "Write-Output 'SOC-Lab PowerShell telemetry test'"
```

PowerShell Script Block Logging generated Event ID **4104** telemetry.

Splunk successfully received the 4104 events.

---

# 6. Detection Engineering

A basic detection was created in Splunk for PowerShell process execution:

```spl
index=main EventCode=4688 "powershell.exe"
```

The detection was validated using actual Windows telemetry generated during the lab.

A host-based aggregation was also tested:

```spl
index=main EventCode=4688 "powershell.exe"
| stats count by host
```

This demonstrated a simple detection-engineering workflow:

```text
Windows Activity
      ↓
Event 4688
      ↓
Splunk
      ↓
Detection Search
      ↓
Suspicious PowerShell Activity
```

---

# 7. Event Correlation and Timeline

PowerShell process creation and Script Block Logging events were combined into an investigation timeline.

Search used:

```spl
index=main (EventCode=4688 OR EventCode=4104)
| sort 0 _time
| table _time EventCode host
```

This allowed the analyst to examine activity chronologically.

The key concept demonstrated was:

> **Individual events provide clues; a timeline provides context.**

---

# 8. Network Activity Simulation

A controlled network connection test was performed from the Windows endpoint:

```powershell
Test-NetConnection 192.168.1.4 -Port 445
```

The result showed:

* Source: `192.168.1.27`
* Destination: `192.168.1.4`
* Destination port: `445`
* ICMP ping succeeded
* TCP connection to port 445 failed

This demonstrated how a SOC analyst can distinguish basic host reachability from successful TCP connectivity.

---

# 9. Persistence Simulation

A harmless scheduled task was created to simulate persistence:

```cmd
schtasks /create /tn "SOC-Lab-TestTask" /tr "cmd.exe /c echo SOC-Lab scheduled task executed >> C:\SOC-Lab\Incident\ScheduledTask_Marker.txt" /sc once /st 23:59 /f
```

The task was then investigated using:

```cmd
schtasks /query /tn "SOC-Lab-TestTask" /fo LIST /v
```

The task was intentionally harmless and existed only to demonstrate how a SOC analyst could identify and investigate scheduled-task persistence.

Windows Task Scheduler telemetry was also checked in Splunk, but the expected Task Scheduler events were not available in the Splunk search during this lab. Therefore, no Splunk Task Scheduler detection is claimed.

---

# 10. Investigation Findings

The simulated incident produced several useful investigation indicators:

| Indicator              | Observation                                           |
| ---------------------- | ----------------------------------------------------- |
| Source system          | Kali test machine                                     |
| Windows endpoint       | `192.168.1.27`                                        |
| Account                | `SOC-Lab`                                             |
| Authentication         | Failed attempts followed by successful authentication |
| Process                | PowerShell                                            |
| Event ID               | 4688                                                  |
| PowerShell telemetry   | Event ID 4104                                         |
| Persistence simulation | Scheduled task                                        |
| Network test           | TCP 445 connection attempt                            |

The investigation demonstrated how authentication, process, PowerShell, network and persistence information can be combined into an incident narrative.

---

# 11. Containment

A temporary Windows Firewall rule was created to block SMB traffic from the controlled test source:

```cmd
netsh advfirewall firewall add rule name="SOC-Lab-Containment" dir=in action=block protocol=TCP localport=445 remoteip=192.168.1.4
```

This represented the containment phase of the incident response process.

The objective was to restrict the suspected source from reaching the SMB service while the investigation and cleanup were performed.

---

# 12. Eradication

The simulated persistence mechanism and harmless test artifacts were removed.

The scheduled task was deleted:

```cmd
schtasks /delete /tn "SOC-Lab-TestTask" /f
```

The simulated artifacts were removed from:

```text
C:\SOC-Lab\Incident\
```

The task was subsequently queried again and was no longer present.

---

# 13. Recovery

After containment and eradication, the temporary containment firewall rule was removed:

```cmd
netsh advfirewall firewall delete rule name="SOC-Lab-Containment"
```

Final verification confirmed:

* The containment firewall rule no longer existed
* The simulated scheduled task no longer existed
* The temporary test artifacts had been removed
* The incident directory contained only the lab README

This completed the recovery stage.

---

# 14. Alert Configuration Note

A scheduled Splunk alert was configured for the PowerShell detection.

The alert was tested with different scheduling and trigger settings.

The detection search itself successfully returned the expected PowerShell events.

However, the automated alert action was **not successfully demonstrated as firing through the Splunk alert history/action log** during this version of the lab.

Therefore, this project does **not** claim successful automated alert execution.

A simpler scheduled-alert test will be performed separately as a future improvement.

---

# 15. Incident Response Lifecycle

The complete workflow demonstrated in this project was:

```text
1. Attack Simulation
        ↓
2. Telemetry Generation
        ↓
3. Detection
        ↓
4. Investigation
        ↓
5. Timeline Construction
        ↓
6. Containment
        ↓
7. Eradication
        ↓
8. Recovery
        ↓
9. Lessons Learned
```

---

# 16. Lessons Learned

### Detection

Simple, reliable searches are often better starting points than complicated correlation queries.

### Investigation

A single event rarely provides enough context. Combining timestamps, users, source IPs, event IDs and process information produces a stronger investigation.

### PowerShell

PowerShell process creation and Script Block Logging provide complementary telemetry:

* **4688** → process creation
* **4104** → PowerShell script block activity

### Persistence

Scheduled tasks are an important Windows persistence mechanism that should be investigated when unexpected tasks appear.

### Incident Response

Detection is only one part of SOC work.

A complete investigation should continue through:

**Detection → Investigation → Containment → Eradication → Recovery**

### Lab Discipline

Security testing should be performed in a controlled environment and temporary firewall rules or test artifacts should be removed after testing.

---

# 17. Evidence

Selected evidence from the lab includes:

* Initial Nmap reconnaissance
* SMB verification
* Failed authentication events (4625)
* Successful authentication event (4624)
* PowerShell process creation (4688)
* Standard-user verification
* PowerShell detection results
* PowerShell event timeline
* Network connection test
* Scheduled-task creation
* Scheduled-task investigation
* Firewall containment
* Eradication
* Recovery

All evidence was generated from the user's controlled lab environment.

---

# 18. Skills Demonstrated

### Windows Security

* Windows Event Viewer
* Security Event IDs
* Authentication investigation
* Process Creation auditing
* PowerShell logging
* Scheduled-task investigation
* Windows Firewall

### SIEM / Splunk

* Windows log collection
* Event searching
* Detection engineering
* Event correlation
* Timeline analysis
* Alert configuration

### SOC Operations

* Alert investigation
* Evidence collection
* Incident timeline construction
* Containment
* Eradication
* Recovery
* Lessons learned

### Security Tools

* Nmap
* Splunk
* Windows Event Viewer
* Windows Firewall
* Windows command-line tools

---

# Conclusion

This project demonstrates an end-to-end **Windows SOC investigation and incident-response workflow** using a controlled lab environment.

Rather than focusing only on identifying an individual alert, the project demonstrates the broader SOC process:

**Generate activity → collect telemetry → detect → investigate → contain → eradicate → recover → document.**

The project was intentionally performed with harmless simulations so that the complete detection and response lifecycle could be practiced safely.
