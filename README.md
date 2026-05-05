# 🚀 Advanced Windows Endpoint Audit using Ansible

## 📌 Overview

This project demonstrates how to use Ansible to perform a **comprehensive audit of Windows endpoints** from a Linux-based control node.

The playbook collects critical system, security, and configuration data from remote Windows machines and generates **structured audit reports** on the control node.

---

## 🎯 Key Features

* 🔍 Hardware inventory collection (Model, Serial Number, RAM)
* 🖥️ OS & Registry insights (Windows Version, Build)
* Security Updates
* Installed Apps
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

### Managed Node (Windows)

* WinRM enabled
* PowerShell 5.1+
* Administrator privileges (recommended)
* You can run below Powershell to Configure WinRM and other required details.
    $url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
    $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
    powershell.exe -ExecutionPolicy ByPass -File $file

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
