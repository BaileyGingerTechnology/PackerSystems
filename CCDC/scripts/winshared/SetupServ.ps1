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

Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName "gingertech.com" `
-SafeModeAdministratorPassword:(ConvertTo-SecureString -String password -AsPlainText -Force) `
-DomainNetbiosName "GINGERTECH" `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true


Import-Module ActiveDirectory
Import-Csv -Delimiter : -Path "C:\userlist.csv" | foreach-object {
    $userprinicpalname = $_.SamAccountName + "@gingertech.com"
    New-ADUser -Server localhost -SamAccountName $_.SamAccountName -UserPrincipalName $userprinicpalname -Name $_.Firstname -DisplayName $_.Firstname -GivenName $_.Firstname -SurName $_.Lastname -Department $_.Department -Path "CN=Users,DC=gingertech,DC=com" -AccountPassword (ConvertTo-SecureString "password" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru
}