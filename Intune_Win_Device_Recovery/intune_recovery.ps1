param (
    [string]$LogPath = "C:\Temp\IntuneRecovery.log"
)

# $LogFile = "C:\Temp\IntuneRecovery.log"
Start-Transcript -Path $LogPath -Append

Write-Host "=== Intune Recovery Started ==="

# 1. Leave Entra ID
Write-Host "Leaving Azure AD..."
dsregcmd /leave

Start-Sleep -Seconds 10

# 2. Locate Intune Enrollment ID
$EnrollmentTasks = Get-ScheduledTask | Where-Object {
    $_.TaskName -like "*PushLaunch*" -or $_.TaskName -like "*OmadmClient*"
}

$EnrollmentID = ($EnrollmentTasks | Select-Object -First 1).TaskPath -replace "\\", ""

Write-Host "Enrollment ID: $EnrollmentID"

# 3. Remove Scheduled Tasks
Write-Host "Removing enrollment scheduled tasks..."
$EnrollmentTasks | Unregister-ScheduledTask -Confirm:$false

# 4. Remove Enrollment Registry Keys
$RegPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Enrollments\$EnrollmentID",
    "HKLM:\SOFTWARE\Microsoft\Enrollments\Status\$EnrollmentID",
    "HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$EnrollmentID"
)

foreach ($Path in $RegPaths) {
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Recurse -Force
        Write-Host "Removed $Path"
    }
}

# 5. Remove MDM Certificates
Write-Host "Removing Intune/MDM certificates..."
Get-ChildItem Cert:\LocalMachine\My |
Where-Object { $_.Issuer -like "*Microsoft Intune*" } |
Remove-Item -Force

# 6. Rejoin Entra ID
Write-Host "Rejoining Azure AD..."
dsregcmd /join

Start-Sleep -Seconds 15

# 7. Trigger MDM Auto Enrollment
Write-Host "Triggering MDM enrollment..."
Start-Process -FilePath "deviceenroller.exe" -ArgumentList "/c /autoenrollmdm" -Wait

# 8. Restart MECM Agent (if present)
$CcmService = Get-Service -Name CcmExec -ErrorAction SilentlyContinue
if ($CcmService) {
    Restart-Service CcmExec -Force
    Write-Host "MECM agent restarted"
}

Write-Host "=== Intune Recovery Completed ==="
Stop-Transcript
