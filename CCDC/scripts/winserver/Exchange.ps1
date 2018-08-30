# Whew boi, kill me now
Set-Location -Path E:\ -PassThru
.\Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
.\Setup.exe /PrepareAD /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
.\Setup.exe /PrepareAD /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
.\Setup.exe /mode:Install /role:Mailbox /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
# Theoretically Exchange might be installed?

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "blog.gingertechnology.net"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1

# The rest of this script disables auto-logon
$Regkey = "HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon"
$DefaultUserName = ''
$DefaultPassword = ''

# This function just gets $true or $false
function Test-RegistryValue($path, $name) {
  $key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
  $key -and $null -ne $key.GetValue($name, $null)
}

# Gets the specified registry value or $null if it is missing
function Get-RegistryValue($path, $name) {
  $key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
  if ($key) {$key.GetValue($name, $null)}
}

#AutoAdminLogon Value
$AALRegValExist = Test-RegistryValue $Regkey AutoAdminLogon
$AALRegVal = Get-RegistryValue $RegKey AutoAdminLogon

if ($AALRegValExist -eq $null) {
  New-ItemProperty -Path $Regkey -Name AutoAdminLogon -Value 0
}

elseif ($AALRegVal -ne 0) {
  Set-ItemProperty -Path $Regkey -Name AutoAdminLogon -Value 0
}

#DefaultUserName Value
$DUNRegValExist = Test-RegistryValue $Regkey DefaultUserName
$DUNRegVal = Get-RegistryValue $RegKey DefaultUserName

if ($DUNRegValExist -eq $null) {
  New-ItemProperty -Path $Regkey -Name DefaultUserName -Value $DefaultUserName
}

elseif ($DUNRegVal -ne $DefaultUserName) {
  Set-ItemProperty -Path $Regkey -Name DefaultUserName -Value $DefaultUserName
}

#DefaultPassword Value
$DPRegValExist = Test-RegistryValue $Regkey DefaultPassword
$DPRegVal = Get-RegistryValue $RegKey DefaultPassword

if ($DPRegValExist -eq $null) {
  New-ItemProperty -Path $Regkey -Name DefaultPassword -Value $DefaultPassword
}

elseif ($DPRegVal -ne $DefaultPassword) {
  Set-ItemProperty -Path $Regkey -Name DefaultPassword -Value $DefaultPassword
}