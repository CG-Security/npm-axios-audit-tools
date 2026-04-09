![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![Security Tool](https://img.shields.io/badge/Security-Audit%20Tool-red.svg)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

# npm Axios Supply Chain Audit Tools

This repository contains PowerShell scripts and documentation to help detect whether Windows endpoints may be affected by the Axios npm supply chain attack attributed to UNC1069, a North Korea-nexus threat actor.

The goal is to answer two questions:

1. Does this machine have npm installed?
2. If yes, are any known malicious packages or IOC artifacts present?

---

## Repository Structure

```text
scripts/
├─ Invoke-AxiosIOCScan.ps1
└─ Audit-AxiosPackages.ps1

docs/
└─ incident-summary.md
```

---

## 1. IOC Scan

Use this script to check a Windows endpoint for known indicators of compromise associated with the Axios supply chain attack.

Run:

```powershell
.\scripts\Invoke-AxiosIOCScan.ps1
```

This script checks:

- Whether npm is installed on the endpoint
- Whether the Windows RAT artifact (`wt.exe`) is present in `%PROGRAMDATA%`
- Whether the RAT persistence batch file (`system.bat`) is present in `%PROGRAMDATA%`
- Whether a RAT persistence registry key (`MicrosoftUpdate`) exists under `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`
- Whether the C2 domain (`sfrclak.com`) appears in the local DNS cache

If npm is not installed, the machine is considered out of scope for package-level auditing. If any IOC is detected, treat the machine as potentially compromised.

---

## 2. Package Audit

Use this script to check Node.js project directories for known compromised package versions.

Run:

```powershell
.\scripts\Audit-AxiosPackages.ps1 -RootPath 'C:\Projects'
```

This script will:

- Recursively locate all `package.json` files under the root path
- Check each project for the presence of compromised Axios versions
- Clearly mark each project as Clean or SUSPICIOUS

**Compromised versions:**

- `axios@1.14.1`
- `axios@0.30.4`
- `plain-crypto-js@4.2.1`

**Safe versions:**

- `axios@1.14.0` or earlier
- `axios@0.30.3` or earlier

The script is read-only. It does not modify any files or upload data.

---

## Usage

Clone the repository:

```powershell
git clone https://github.com/CG-Security/npm-axios-audit-tools.git
cd npm-axios-audit-tools
```

Run the IOC scan:

```powershell
.\scripts\Invoke-AxiosIOCScan.ps1
```

Run the package audit against your projects directory:

```powershell
.\scripts\Audit-AxiosPackages.ps1 -RootPath 'C:\Projects'
```

Both tools are read-only and safe to run on developer machines.

---

## Additional Documentation

A high-level summary of the Axios supply chain attack and how these tools support triage:

- [docs/incident-summary.md](docs/incident-summary.md)

---

## Disclaimer

These scripts:

- Do not alter project files
- Do not transmit data
- Are intended for triage and discovery only
- Should be used alongside SIEM searches, EDR results, and standard IR processes

Use these tools responsibly and verify findings against trusted threat intelligence sources.
