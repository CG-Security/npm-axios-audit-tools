# Incident Summary: Axios npm Supply Chain Attack

## Overview

On March 31, 2026, two malicious versions of the Axios npm package were published to the npm registry via a compromised maintainer account. Axios is one of the most widely used JavaScript HTTP client libraries, with approximately 100 million weekly downloads.

The attack has been attributed to UNC1069, a North Korea-nexus, financially motivated threat actor tracked by Google Threat Intelligence Group (GTIG) and Microsoft (Sapphire Sleet).

---

## Attack Summary

The attacker compromised the npm account of the primary Axios maintainer and published two backdoored versions:

- `axios@1.14.1` — tagged latest
- `axios@0.30.4` — tagged legacy

Both versions injected a malicious dependency, `plain-crypto-js@4.2.1`, which executed a postinstall script (`setup.js`) that deployed a cross-platform Remote Access Trojan (RAT) tracked as WAVESHAPER.V2. The malware targeted Windows, macOS, and Linux systems and beaconed to a C2 server every 60 seconds.

The malicious versions were live for approximately 2-3 hours before being pulled from the registry.

---

## Compromised Packages

| Package | Version | Status |
|---|---|---|
| axios | 1.14.1 | Malicious |
| axios | 0.30.4 | Malicious |
| plain-crypto-js | 4.2.1 | Malicious |

**Safe versions:** `axios@1.14.0` or earlier, `axios@0.30.3` or earlier

---

## Network Indicators of Compromise

| Indicator | Type | Notes |
|---|---|---|
| `sfrclak.com` | C2 Domain | WAVESHAPER.V2 |
| `142.11.206.73` | C2 IP | WAVESHAPER.V2 |
| `http://sfrclak.com:8000` | C2 URL | WAVESHAPER.V2 |
| `http://sfrclak.com:8000/6202033` | C2 URL | WAVESHAPER.V2 |
| `23.254.167.216` | C2 IP | Suspected UNC1069 Infrastructure |

---

## File Indicators of Compromise (Windows)

| Artifact | Path | Notes |
|---|---|---|
| RAT binary | `%PROGRAMDATA%\wt.exe` | Disguised as Windows Terminal |
| Persistence batch file | `%PROGRAMDATA%\system.bat` | Hidden batch file |
| Registry persistence | `HKCU\Software\Microsoft\Windows\CurrentVersion\Run\MicrosoftUpdate` | RAT autorun entry |

---

## Attribution

Google Threat Intelligence Group attributed this attack to UNC1069, a North Korea-nexus threat actor active since at least 2018. Microsoft tracks the same actor as Sapphire Sleet. The group is financially motivated and has historically targeted cryptocurrency exchanges, financial institutions, and software developers.

---

## References

- [Google Threat Intelligence Group](https://cloud.google.com/blog/topics/threat-intelligence/north-korea-threat-actor-targets-axios-npm-package)
- [StepSecurity](https://www.stepsecurity.io/blog/axios-compromised-on-npm-malicious-versions-drop-remote-access-trojan)
- [Elastic Security Labs](https://www.elastic.co/security-labs/axios-one-rat-to-rule-them-all)
- [Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/2026/04/01/mitigating-the-axios-npm-supply-chain-compromise)
