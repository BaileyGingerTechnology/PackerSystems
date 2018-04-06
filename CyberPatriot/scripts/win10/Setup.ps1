# Author: Bailey Kasin
# This script sets/messes up the Windows 10 image

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

# Disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# User creation
$Users = Import-Csv -Delimiter : -Path "C:\userlist.csv"
foreach ($User in $Users)
{
    $Displayname = $User.'Firstname' + " " + $User.'Lastname'
    $UserFirstname = $User.'Firstname'
    $Description = $User.'Description'
    New-LocalUser $UserFirstname -NoPassword -FullName $Displayname -Description $Description
    Write-Host "User " + $UserFirstname + " has been made."
}

# Disable autologon
$Regkey= "HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon"
$DefaultUserName = ''
$DefaultPassword = ''

# This function just gets $true or $false
function Test-RegistryValue($path, $name)
{
    $key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
    $key -and $null -ne $key.GetValue($name, $null)
}

# Gets the specified registry value or $null if it is missing
function Get-RegistryValue($path, $name)
{
    $key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
    if ($key) {$key.GetValue($name, $null)}
}

#AutoAdminLogon Value
$AALRegValExist = Test-RegistryValue $Regkey AutoAdminLogon
$AALRegVal = Get-RegistryValue $RegKey AutoAdminLogon

if ($AALRegValExist -eq $null)
{
    New-ItemProperty -Path $Regkey -Name AutoAdminLogon -Value 0
}

elseif ($AALRegVal -ne 0)
{
    Set-ItemProperty -Path $Regkey -Name AutoAdminLogon -Value 0
}

#DefaultUserName Value
$DUNRegValExist = Test-RegistryValue $Regkey DefaultUserName
$DUNRegVal = Get-RegistryValue $RegKey DefaultUserName

if ($DUNRegValExist -eq $null)
{
    New-ItemProperty -Path $Regkey -Name DefaultUserName -Value $DefaultUserName
}

elseif ($DUNRegVal -ne $DefaultUserName)
{
    Set-ItemProperty -Path $Regkey -Name DefaultUserName -Value $DefaultUserName
}

#DefaultPassword Value
$DPRegValExist = Test-RegistryValue $Regkey DefaultPassword
$DPRegVal = Get-RegistryValue $RegKey DefaultPassword

if ($DPRegValExist -eq $null)
{
    New-ItemProperty -Path $Regkey -Name DefaultPassword -Value $DefaultPassword
}

elseif ($DPRegVal -ne $DefaultPassword)
{
    Set-ItemProperty -Path $Regkey -Name DefaultPassword -Value $DefaultPassword
}

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "proxy.google.com"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1

# Import reg file for all other keys
regedit /s c:\registryKeys.reg