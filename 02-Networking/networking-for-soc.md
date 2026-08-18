# Networking for SOC Analysis

## Overview

Networking knowledge is essential for a SOC Analyst because security events often involve network communication.

Understanding IP addresses, ports, protocols, DNS, ARP, TCP, and UDP helps analysts investigate suspicious network activity.

## Important Concepts

### IP Address

An IP address identifies a device/interface on a network.

SOC analysts use IP addresses to investigate:

- Source of connections
- Destination systems
- Suspicious communication
- Internal and external traffic

### MAC Address

A MAC address identifies a network interface at the data-link layer.

It can be useful when investigating activity within a local network.

### TCP

TCP is a connection-oriented transport protocol.

Important concepts include:

- Three-way handshake
- Source and destination ports
- Reliable delivery
- Connection states

### UDP

UDP is a connectionless transport protocol.

It is commonly used by services such as DNS and can also appear in network-based attacks.

### DNS

DNS translates domain names into IP addresses.

SOC analysts can investigate DNS logs to identify:

- Suspicious domains
- Malware-related communication
- Unusual DNS requests
- Connections to known malicious infrastructure

### ARP

ARP maps IPv4 addresses to MAC addresses on a local network.

Attackers can abuse ARP through techniques such as ARP spoofing.

## Important Commands

```bash
ip a
