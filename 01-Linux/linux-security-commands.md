# Linux Security Commands

## Overview

Linux command-line tools are important for system administration, troubleshooting, and cybersecurity investigations.

As a SOC Analyst, these commands can help investigate processes, network connections, files, permissions, and system logs.

## Important Commands

| Command | What it does | SOC Use |
|---|---|---|
| `pwd` | Shows the current directory | Understand the current location |
| `ls` | Lists files and directories | Inspect files |
| `cd` | Changes directory | Navigate through the filesystem |
| `cat` | Displays file contents | Read configuration and log files |
| `grep` | Searches for text | Search logs for suspicious activity |
| `find` | Searches for files | Locate suspicious or important files |
| `ps aux` | Shows running processes | Investigate suspicious processes |
| `pstree` | Shows processes as a tree | Understand parent-child processes |
| `ss -tuln` | Shows listening network sockets | Identify listening services |
| `ip a` | Shows network interfaces and IP addresses | Investigate network configuration |
| `ip r` | Shows routing table | Understand network routes |
| `journalctl` | Displays system logs | Investigate system activity |
| `systemctl` | Manages system services | Investigate running services |
| `chmod` | Changes file permissions | Investigate or modify permissions |
| `chown` | Changes file ownership | Investigate file ownership |

## Example Investigation

### Scenario

A SOC analyst suspects that a Linux machine may be running an unusual process and listening for network connections.

### Step 1 — Check running processes

```bash
ps aux










## Next Steps

- Practice Linux log analysis
- Investigate authentication logs
- Practice identifying suspicious processes
- Use Bash to automate repetitive security tasks
