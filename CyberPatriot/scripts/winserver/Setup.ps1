# Author: Bailey Kasin
# This script setups/messes up the Windows Server image

# Share the C:\ drive, because duh, that's a great idea
net share FullDrive=C:\ /grant:Everyone,Full

function Disable-PasswordComplexity
{
    param()

    $secEditPath = [System.Environment]::ExpandEnvironmentVariables("%SystemRoot%\system32\secedit.exe")
    $tempFile = [System.IO.Path]::GetTempFileName()

    $exportArguments = '/export /cfg "{0}" /quiet' -f $tempFile
    $importArguments = '/configure /db secedit.sdb /cfg "{0}" /quiet' -f $tempFile

    Start-Process -FilePath $secEditPath -ArgumentList $exportArguments -Wait

    $currentConfig = Get-Content -Path $tempFile

    $currentConfig = $currentConfig -replace 'PasswordComplexity = .', 'PasswordComplexity = 0'
    $currentConfig = $currentConfig -replace 'MinimumPasswordLength = .', 'MinimumPasswordLength = 0'
    $currentConfig | Out-File -FilePath $tempFile

    Start-Process -FilePath $secEditPath -ArgumentList $importArguments -Wait
   
    Remove-Item -Path .\secedit.sdb
    Remove-Item -Path $tempFile
}

# Passwords are for the weak
Disable-PasswordComplexity

# Setup some fun routing using the hosts file
Add-Content C:\Windows\System32\drivers\etc\hosts "34.196.155.28 google.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 bing.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 yahoo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 duckduckgo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 startpage.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 aol.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "34.196.155.28 www.google.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.bing.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.yahoo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.duckduckgo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.startpage.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.aol.com"

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "proxy.google.com"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1

# Disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName "gingertech.com" `
-SafeModeAdministratorPassword:(ConvertTo-SecureString -String UberPassword -AsPlainText -Force) `
-DomainNetbiosName "GINGERTECH" `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

# Mwuahahaha suffer with Exhange
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature AS-HTTP-Activation, Desktop-Experience, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

$file = "C:\Ucma.exe"
if (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\UCMA4" -ErrorAction SilentlyContinue) {
    Write-Host "Unified Communications Managed API 4.0 Runtime is already installed." -ForegroundColor Cyan
}
else {
    if (Test-Path $file) {
        Write-Host "The installer file exists: $file" -ForegroundColor Green
        Write-Host "Installing Microsoft UM API" -ForegroundColor Yellow
        $arg = "/quiet /norestart"
        $status = (Start-Process $file -ArgumentList $arg -Wait -PassThru).ExitCode
        if ($status -eq 0) {
            Write-Host "Successful install" - -ForegroundColor Green
        }
        if ($status -ne 0) {
            Write-Host "Failed install" -ForegroundColor Red
        }
    }
    else {
        Write-Host "$file does not exist" -ForegroundColor Red
    }
}

Install-WindowsFeature ADLDS