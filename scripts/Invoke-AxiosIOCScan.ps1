<#
.SYNOPSIS
    Scans a Windows endpoint for known IOCs associated with the Axios npm supply chain attack (UNC1069 / WAVESHAPER.V2).

.DESCRIPTION
    Checks for the presence of RAT artifacts, persistence mechanisms, npm installation status,
    and C2 domain presence in the local DNS cache.

.NOTES
    Read-only. Does not modify any files or transmit data.
    Run as Local System or Administrator for best results.
#>

$user           = (Get-WmiObject Win32_ComputerSystem).Username
$ratFound       = Test-Path "$env:PROGRAMDATA\wt.exe"
$systemBat      = Test-Path "$env:PROGRAMDATA\system.bat"
$npmInstalled   = $null -ne (Get-Command npm -ErrorAction SilentlyContinue)
$c2InDNSCache   = $null -ne (Get-DnsClientCache | Where-Object { $_.Entry -like "*sfrclak*" })
$ratPersistence = $null -ne (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "MicrosoftUpdate" -ErrorAction SilentlyContinue)

Write-Output "=============================="
Write-Output "Axios IOC Scan - $env:COMPUTERNAME"
Write-Output "=============================="
Write-Output "User:            $user"
Write-Output "RAT Found:       $ratFound"
Write-Output "System.bat:      $systemBat"
Write-Output "NPM Installed:   $npmInstalled"
Write-Output "C2 in DNS:       $c2InDNSCache"
Write-Output "RAT Persistence: $ratPersistence"
Write-Output "=============================="
