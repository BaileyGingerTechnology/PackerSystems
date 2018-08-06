Import-Module ActiveDirectory
Import-Csv -Delimiter : -Path "C:\userlist.csv" | foreach-object {
  $userprinicpalname = $_.SamAccountName + "@gingertech.com"
  New-ADUser -Server localhost -SamAccountName $_.SamAccountName -UserPrincipalName $userprinicpalname -Name $_.Firstname -DisplayName $_.Firstname -GivenName $_.Firstname -SurName $_.Lastname -Department $_.Department -Path "CN=Users,DC=gingertech,DC=com" -AccountPassword (ConvertTo-SecureString "password" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru
}

Add-ADGroupMember -Identity 'Enterprise Admins' -Members “GingerTech”
Add-ADGroupMember -Identity 'Schema Admins' -Members “GingerTech”

$group = Get-ADGroup "Enterprise Admins" -properties @("primaryGroupToken")
Get-ADUser "GingerTech" | Set-ADUuser -replace @{primaryGroupID = $group.primaryGroupToken}