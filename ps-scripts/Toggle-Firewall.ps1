# Toggle-Firewall.ps1
# If firewall is ON (any profile), turn it OFF for all profiles. Otherwise turn it ON.
# Self-elevates to admin.

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
  Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
  exit
}

$profiles = Get-NetFirewallProfile
$anyEnabled = $profiles | Where-Object { $_.Enabled -eq 'True' }

if ($anyEnabled) {
  Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
  Write-Host "Firewall: DISABLED (all profiles)"
} else {
  Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
  Write-Host "Firewall: ENABLED (all profiles)"
}

pause