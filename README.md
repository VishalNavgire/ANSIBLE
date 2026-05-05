# 🚀 Advanced Windows Endpoint Audit using Ansible

## 📌 Overview

This project demonstrates how to use Ansible to perform a **comprehensive audit of Windows endpoints** from a Linux-based control node.

The playbook collects critical system, security, and configuration data from remote Windows machines and generates **structured audit reports** on the control node.

---

## 🎯 Key Features

* 🔍 Hardware inventory collection (Model, Serial Number, RAM)
* 🖥️ OS & Registry insights (Windows Version, Build)
* 🛡️ Security updates tracking (Hotfix & patch visibility)
* 📦 Installed applications inventory (Name, Version, Publisher)
* 👤 User profile discovery via registry
* 🔐 Local Administrators group audit
* 📅 Scheduled tasks inspection
* ☁️ Microsoft Entra ID (Azure AD) join status
* 📄 Clean, human-readable reports using Jinja2 templates
* 📁 Centralized report storage on control node

---

## 🏗️ Architecture

```
Fedora (Control Node)
        │
        │  WinRM (Remote Execution)
        ▼
Windows Endpoints (Managed Nodes)
        │
        ▼
Audit Reports (Stored Locally on Control Node)
```

---

## 📂 Project Structure

```
Windows_Hw_Inventory/
├── templates/
│   └── audit_report.j2
├── Windows_Endpoint_Audit.yml
└── README.md
```

---

## ⚙️ Prerequisites

### Control Node (Linux - Fedora)

* Python 3.x
* Ansible installed
* WinRM configured for Windows connectivity

### 🖥️ Managed Node (Windows)

To successfully manage Windows endpoints using Ansible, ensure the following prerequisites are met on each managed node:

---

#### ✅ Requirements

* **WinRM (Windows Remote Management)** must be enabled and properly configured
* **PowerShell 5.1 or later** must be available
* **Administrator privileges** are recommended for full audit capabilities
* Network connectivity between Control Node and Managed Node must be open (default WinRM ports: `5985` HTTP / `5986` HTTPS)

---

#### ⚙️ Quick Configuration (Recommended)

Run the following PowerShell script on the Windows machine to automatically configure WinRM and required settings:

```powershell
$url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file
```

This script will:

* Enable WinRM
* Configure listeners
* Adjust firewall rules
* Set authentication methods compatible with Ansible

---

#### 🔍 Validation Checks (Important)

After configuration, verify that the system is ready for Ansible:

---

##### 1. Check WinRM Service Status

```powershell
Get-Service WinRM
```

✅ Expected:

```
Status   Name   DisplayName
------   ----   -----------
Running  WinRM  Windows Remote Management
```

---

##### 2. Verify WinRM Listener

```powershell
winrm enumerate winrm/config/listener
```

✅ Confirms that WinRM is actively listening for connections.

---

##### 3. Test WinRM Connectivity Locally

```powershell
Test-WSMan
```

✅ Should return protocol details without errors.

---

##### 4. Check PowerShell Version

```powershell
$PSVersionTable.PSVersion
```

✅ Ensure version is **5.1 or higher**

---

##### 5. Verify Local Administrator Access

```powershell
whoami /groups
```

✅ Confirm the user is part of the **Administrators** group

---

##### 6. Firewall Rule Validation

```powershell
Get-NetFirewallRule -DisplayName "*WinRM*"
```

✅ Ensure WinRM-related rules are enabled

---

##### 7. Remote Connectivity Test from Control Node (Linux)

From your control node, run:

```bash
ansible windows -i inventory.ini -m win_ping
```

✅ Expected output:

```
"ping": "pong"
```

---

#### ⚠️ Common Issues

* WinRM service not running
* Firewall blocking ports 5985/5986
* Incorrect credentials or authentication method
* PowerShell remoting not enabled
* Non-admin user lacking required permissions

---

#### 💡 Pro Tip

For production environments:

* Prefer **HTTPS (5986)** over HTTP
* Use **Kerberos or certificate-based authentication**
* Avoid Basic authentication unless in lab environments

---


---

## ▶️ How to Run

```bash
ansible-playbook -i inventory.ini Windows_Endpoint_Audit.yml
```

---

## 📄 Sample Output

```
===== Windows Endpoint Audit Report =====

Timestamp: 2026-05-05 15:59:38
Host: Win11-FedoraVM

--- Hardware ---
Model: Virtual Machine
Serial: ABC123XYZ
RAM (GB): 8

--- OS Info ---
Product: Windows 11 Pro
Version: 23H2
Build: 22631

--- User Profiles ---
- C:\Users\Administrator (S-1-5-21-XXXX)
- C:\Users\Vishal (S-1-5-21-YYYY)

--- Local Administrators ---
- Administrator (User)
- Domain Admins (Group)

--- Scheduled Tasks ---
- Task1 (\Microsoft\Windows\...)
- Task2 (\Custom\...)

--- Entra ID Status ---
AzureAdJoined : YES
DeviceDisplayName : Win11-FedoraVM
```

---

## 🧠 Key Concepts Demonstrated

### 🔹 Ansible for Windows Automation

Using `ansible.windows.win_powershell` to execute complex PowerShell scripts remotely.

### 🔹 Jinja2 Templating

Separation of logic and presentation using `.j2` templates for clean reporting.

### 🔹 Delegation

```yaml
delegate_to: localhost
```

Used to store results on the control node instead of remote systems.

### 🔹 Idempotent Design

* Read-only audit tasks
* `changed_when: false` ensures accurate reporting

---

## 🔐 Security Insights Captured

* Local Administrator group membership
* User profile enumeration
* Device identity status (Entra ID / Azure AD)

---

## 🚀 Future Enhancements

* 📊 Export reports to CSV / Excel
* ☁️ Upload reports to cloud storage (Azure / AWS)
* 🔁 Schedule periodic audits via cron / pipeline
* 📦 Convert into reusable Ansible Role

---

## 💡 Why This Project Matters

This project reflects real-world skills required for:

* Endpoint Management (Intune / SCCM)
* Cloud Identity (Entra ID / Azure AD)
* Infrastructure Automation (Ansible)
* Security Auditing & Compliance
