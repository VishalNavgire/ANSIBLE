<div align="center">

# 🚀 Intune Windows Device Recovery Automation using Ansible & PowerShell

[![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-5391FE?logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![Ansible](https://img.shields.io/badge/Ansible-2.15%2B-EE0000?logo=ansible&logoColor=white)](https://docs.ansible.com/)
[![Microsoft Graph](https://img.shields.io/badge/Microsoft%20Graph-API-0078D4?logo=microsoft&logoColor=white)](https://developer.microsoft.com/en-us/graph)
[![Intune](https://img.shields.io/badge/Microsoft%20Intune-Management-blue?logo=microsoft&logoColor=white)](https://learn.microsoft.com/mem/intune/)
[![Automation](https://img.shields.io/badge/Automation-Endpoint%20Management-green)]()
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

**Enterprise-grade automation solution to recover broken Microsoft Intune communication on Windows endpoints using Ansible and PowerShell.**

</div>

---

# 📖 Overview

In enterprise environments, Windows devices may occasionally lose communication with:

Microsoft Intune
Microsoft Entra ID (Azure AD)
MDM enrollment services
Device authentication services

This can lead to:

❌ Devices disappearing from Intune compliance
❌ Failed policy deployments
❌ Broken application deployments
❌ Failed device synchronization
❌ Autopilot provisioning issues
❌ Compliance reporting gaps
❌ Conditional Access failures

Manually recovering these devices is time-consuming and operationally risky.

This project provides a fully automated recovery workflow using:

🟥 Ansible
🟦 PowerShell
☁️ Microsoft Entra ID
💻 Microsoft Intune
🔐 WinRM remote management

The solution performs controlled remediation steps to restore healthy communication between Windows endpoints and Intune.

---

# 🎯 Key Features

| Feature                        | Description                                        |
| ------------------------------ | -------------------------------------------------- |
| 🔍 Preflight validation        | Checks device join and enrollment status           |
| ⚡ Automated recovery workflow  | Repairs broken Intune communication                |
| ☁️ Entra ID validation         | Verifies Azure AD join state                       |
| 🔄 Intune re-enrollment        | Triggers fresh MDM enrollment                      |
| 📋 Scheduled task cleanup      | Removes broken enrollment tasks                    |
| 🧹 Registry remediation        | Cleans stale enrollment registry entries           |
| 🔐 Certificate cleanup         | Removes invalid Intune MDM certificates            |
| 🖥️ MECM compatibility         | Restarts MECM agent if installed                   |
| 📄 Centralized logging         | Fetches recovery logs to control node              |
| 🚦 Batch execution control     | Limits blast radius using Ansible serial execution |
| 🛡️ Safer enterprise execution | Skips already healthy devices automatically        |

---

# 🏗️ Architecture

```
Fedora / Linux Control Node
        │
        │  (WinRM)
        ▼
Windows Endpoints
        │
        ├── Preflight Validation
        │
        ├── dsregcmd /status Analysis
        │
        ├── Broken Enrollment Detection
        │
        ├── Remove Old Enrollment Artifacts
        │
        ├── Cleanup Registry + Tasks + Certificates
        │
        ├── Trigger Entra Rejoin
        │
        ├── Trigger MDM Auto Enrollment
        │
        └── Post Validation & Logging
```
---

# 📂 Project Structure

    ```
    Intune_Win_Device_Recovery/
    ├── group_vars/
    │   └── all/
    │       └── secrets.yml          # AES-256 Encrypted Tenant/MDM metadata
    ├── logs/                        # Centralized local repository for retrieved logs
    ├── .gitignore                   # Protects logs and passwords from GitHub
    ├── intune_recovery.ps1          # The System-level remediation worker
    └── Intune_Win_Recovery_Code.yml # The Orchestration playbook
    ```

# ⚙️ Technology Stack
## ☁️ Microsoft Technologies
    Microsoft Intune
    Microsoft Entra ID
    WinRM
    Windows MDM Enrollment
    MECM / SCCM (Optional)

## 💻 Automation Technologies
    Ansible
    PowerShell
    YAML


# 🖥️ Supported Platforms
## Control Node
    Fedora Linux
    RHEL
    Ubuntu
    Debian

# 📋 Prerequisites
## 🖥 Control Node (Linux)

    Install Ansible:

        sudo dnf install ansible -y

    Verify installation:

        ansible --version
# 🪟 Managed Node (Windows)
Required Configuration
| Requirement          | Details                               |
| -------------------- | ------------------------------------- |
| WinRM                | Must be enabled                       |
| PowerShell           | Version 5.1+                          |
| Administrator Rights | Recommended                           |
| Network Connectivity | WinRM ports accessible                |
| Microsoft Intune     | Device should already exist in tenant |


# Configure WinRM on Windows
    Run PowerShell as Administrator:

        $url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
        $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
        (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
        powershell.exe -ExecutionPolicy ByPass -File $file

# 🔍 Validate Managed Node Readiness
## Check WinRM
    winrm quickconfig

## Check PowerShell Version
    $PSVersionTable

## Check Entra Join State
    dsregcmd /status

## Check Intune Enrollment Tasks
    Get-ScheduledTask | Where-Object {$_.TaskPath -like "*EnterpriseMgmt*"}


# 📥 Clone the Repository
    git clone https://github.com/VishalNavgire/ANSIBLE.git

    cd ANSIBLE\Intune-Win-Device-Recovery


# 🧾 Configure Inventory

    Example:

    [intune_recovery_targets]

    WIN11-01 ansible_host=192.168.1.50
    WIN11-02 ansible_host=192.168.1.51

    [intune_recovery_targets:vars]

    ansible_user=Administrator
    ansible_password=Password123
    ansible_connection=winrm
    ansible_winrm_transport=ntlm
    ansible_port=5985

# ▶️ Run the Playbook
    ansible-playbook -i <Path of Managed Host Inventory File> playbooks/intune_recovery.yml --vault-password-file ~/.ansible_vault_pass.txt

# 📄 Logs & Output

    Recovery logs are automatically collected to:

    ./logs/

    Example:

    WIN11-01.log


# ⚠️ Production Usage Warning

    This solution performs sensitive remediation operations involving:

    - Microsoft Entra ID join state
    - Intune enrollment artifacts
    - Scheduled tasks
    - Windows registry modifications
    - Device certificates

    It is strongly recommended to:

    - Test thoroughly in a lab environment first
    - Validate against pilot devices
    - Use small execution batches
    - Review logs carefully
    - Confirm Intune communication post-remediation

    Do NOT execute broadly in production without adequate testing and rollback planning.
---

# 👨‍💻 Author

### Vishal Navgire

Cloud & Endpoint Automation Engineer

![Azure](https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge\&logo=microsoftazure\&logoColor=white)
![Microsoft Graph](https://img.shields.io/badge/Microsoft%20Graph-6264A7?style=for-the-badge\&logo=microsoft\&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge\&logo=powershell\&logoColor=white)
![Python](https://img.shields.io/badge/Python-3670A0?style=for-the-badge\&logo=python\&logoColor=ffdd54)

---
