# Import the ActiveDirectory PowerShell module and
# then use it to loop through a CSV file and create
# user accounts
Import-Module ActiveDirectory
Import-Csv -Delimiter : -Path "C:\userlist.csv" | foreach-object {
  $userprinicpalname = $_.SamAccountName + "@gingertech.com"
  New-ADUser -Server localhost -SamAccountName $_.SamAccountName -UserPrincipalName $userprinicpalname -Name $_.Firstname -DisplayName $_.Firstname -GivenName $_.Firstname -SurName $_.Lastname -Department $_.Department -Path "CN=Users,DC=gingertech,DC=com" -AccountPassword (ConvertTo-SecureString "password" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru
}

# Exchange server must be created by a user that's
# part of the Enterprise or Schema Admin groups.
# Setting both does not harm or help
Add-ADGroupMember -Identity 'Enterprise Admins' -Members "GingerTech"
Add-ADGroupMember -Identity 'Schema Admins' -Members "GingerTech"

# Make one of them the primary group for the main
# Exchange admin
$group = Get-ADGroup "Enterprise Admins" -properties @("primaryGroupToken")
Get-ADUser "GingerTech" | Set-ADUser -replace @{primaryGroupID = $group.primaryGroupToken}