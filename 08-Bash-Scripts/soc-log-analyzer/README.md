# SOC Log Analyzer

## Overview

This project is a simple Bash-based security tool designed to help a SOC analyst search and analyze log data.

The goal is to automate basic log-searching tasks that an analyst may perform during an initial investigation.

## Objectives

The tool is designed to help search logs for:

- IP addresses
- Usernames
- Failed authentication attempts
- Suspicious activity
- Important keywords

## Technologies

- Linux
- Bash
- Linux command-line tools
- Log files

## Security Use Case

During a security investigation, a SOC analyst may need to quickly search large amounts of log data.

Instead of manually reading every line, command-line tools can be used to filter and identify potentially relevant events.

## Example Commands

### Search for failed authentication

```bash
grep "failed" logfile.log
