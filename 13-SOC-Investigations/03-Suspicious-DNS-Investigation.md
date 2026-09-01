# SOC Investigation: Suspicious DNS Activity

## Scenario

A SOC Analyst receives an alert after a workstation makes a DNS request for an unfamiliar domain.

The objective is to determine whether the domain and resulting network activity are legitimate or potentially malicious.

## Initial Alert

The alert contains:

- Source workstation
- Source IP address
- Requested domain
- DNS server
- Timestamp
- DNS response

## Investigation Steps

### 1. Identify the Domain

Determine:

- What domain was requested?
- Is the domain known to the organization?
- Is the domain associated with a legitimate service?
- How frequently was it requested?

### 2. Identify the Source

Determine which system generated the request.

Investigate:

- Hostname
- Source IP
- Logged-in user
- Time of request

### 3. Examine the DNS Response

Determine which IP address the domain resolved to.

The analyst can then investigate whether the destination IP is expected or suspicious.

### 4. Investigate Network Connections

After identifying the resolved IP, investigate whether the workstation established a connection with that destination.

Look for:

- TCP connections
- Destination port
- Connection frequency
- Repeated connections
- Unusual outbound traffic

## Wireshark Investigation

Useful Wireshark filters include:

```text
dns
