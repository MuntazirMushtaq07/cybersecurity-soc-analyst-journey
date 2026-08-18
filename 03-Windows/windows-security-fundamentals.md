# Windows Security Fundamentals

## Overview

Windows is widely used in enterprise environments, making Windows security knowledge important for SOC Analysts.

A SOC Analyst needs to understand Windows users, permissions, processes, services, Event Logs, and authentication activity.

## Important Concepts

### Users

Windows users can be local or domain users.

SOC analysts investigate user activity to identify suspicious logins, account misuse, and unauthorized access.

### Groups

Windows groups allow administrators to assign permissions to multiple users.

Examples include:

- Administrators
- Users
- Remote Desktop Users

### NTFS Permissions

NTFS permissions control what users can do with files and folders.

Common permissions include:

- Read
- Write
- Modify
- Full Control

Incorrect permissions can create security risks.

### UAC

User Account Control helps prevent unauthorized changes that require administrative privileges.

It can provide an additional security layer against privilege abuse.

## Windows Event Logs

Windows records many security-related activities in Event Logs.

Important log categories include:

- Security
- System
- Application

The Security log is particularly important for SOC investigations.

## Important Security Events

### Event ID 4624

Successful account logon.

Useful for investigating:

- Unexpected logins
- Unusual login times
- Remote logins
- Suspicious accounts

### Event ID 4625

Failed account logon.

Multiple failures may indicate:

- Brute-force attacks
- Password spraying
- Incorrect credentials
- Unauthorized access attempts

### Event ID 4688

A new process was created.

This can help analysts investigate suspicious processes and command execution.

### Event ID 4672

Special privileges were assigned to a new logon.

This can be important when investigating potentially privileged account activity.

## SOC Investigation Example

A SOC analyst observes:

1. Multiple failed logins
2. A successful login
3. The login uses a privileged account
4. PowerShell starts afterward
5. The system makes an unusual outbound connection

The analyst should correlate these events rather than investigating each event separately.

This can help determine whether the activity represents a legitimate user action or a potential security incident.

## Key Takeaway

Windows Event Logs provide valuable evidence during security investigations.

Understanding users, permissions, authentication, processes, and Event IDs allows a SOC Analyst to investigate suspicious activity more effectively.
