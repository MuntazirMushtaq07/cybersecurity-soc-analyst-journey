# Active Directory Security

## Overview

Active Directory (AD) is Microsoft's directory service used by organizations to manage users, computers, groups, and access to resources within a Windows domain.

Active Directory knowledge is important for SOC Analysts because many enterprise security incidents involve compromised accounts, authentication attacks, privilege abuse, and suspicious activity involving domain systems.

## Important Components

### Domain

A domain is a logical environment where users, computers, and other resources are centrally managed.

### Domain Controller

A Domain Controller is a Windows server that manages authentication and directory services for the domain.

### Users

User accounts allow people and services to authenticate and access resources.

SOC analysts monitor account activity for:

- Unusual logins
- Failed authentication
- Privileged account activity
- Suspicious account creation
- Account misuse

### Groups

Groups allow administrators to assign permissions to multiple users.

Examples include:

- Domain Users
- Domain Admins
- Administrators

Membership in highly privileged groups should be carefully monitored.

## Authentication

Active Directory commonly uses Kerberos for authentication within a domain.

Authentication logs can provide important evidence during security investigations.

## Security Risks

Attackers may attempt to:

- Compromise user accounts
- Perform password spraying
- Perform brute-force attacks
- Abuse privileged accounts
- Create unauthorized accounts
- Escalate privileges
- Move laterally between systems

## SOC Investigation

A SOC analyst may correlate:

1. Multiple failed logins
2. A successful login
3. Authentication from an unusual system
4. Privileged account activity
5. New processes or PowerShell execution
6. Lateral movement indicators

Correlating these events can help determine whether an account has potentially been compromised.

## Key Takeaway

Active Directory is a critical technology in enterprise environments.

Understanding users, groups, authentication, Domain Controllers, and privileges helps SOC Analysts investigate account compromise and lateral movement.
