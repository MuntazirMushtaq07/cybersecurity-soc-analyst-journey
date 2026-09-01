# Splunk for SOC Analysis

## Overview

Splunk is a platform used to collect, search, analyze, and visualize machine-generated data and security logs.

For a SOC Analyst, Splunk can be used to investigate alerts, search events, correlate activity, and identify suspicious behavior.

## Log Searching

Searching logs is one of the most important skills when working with a SIEM.

A SOC Analyst can search for:

- Usernames
- IP addresses
- Event IDs
- Hostnames
- Domains
- Processes
- Authentication activity
- Suspicious commands

## SPL

Splunk uses Search Processing Language (SPL) to search and analyze data.

Example:

```spl
index=main


index=main "failed"
