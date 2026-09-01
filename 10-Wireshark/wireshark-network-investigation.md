# Wireshark Network Investigation

## Overview

Wireshark is a network protocol analyzer used to capture and inspect network traffic.

For a SOC Analyst, Wireshark can help investigate suspicious connections, DNS activity, TCP communication, unusual protocols, and potential malicious traffic.

## DNS Investigation

DNS traffic can be investigated to identify suspicious domain queries.

A basic Wireshark filter is:

```text
dns
