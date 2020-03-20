Import-Module ActiveDirectory
Add-Type -Assembly System.Web

function passchangeREG() {
$adGroupMemberList = Get-ADUser -Filter *

foreach($user in $adGroupMemberList) {
    $newPassword = [Web.Security.Membership]::GeneratePassword(12,0)
    Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)
    $sam = ($user).SamAccountName
    Write-Output "SamAccountName:`n$sam `nPassword:"$newPassword `n`n|FT -AutoSize >>PassChange.txt
}
keys
}

function keys() {
#blocking anonymous user enumeration
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymous /t REG_DWORD /d 1 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymoussam /t REG_DWORD /d 1 /f
#blocking everyone permissions
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v everyoneincludesanonymous /t REG_DWORD /d 0 /f
#enable UAC
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
#disable anonymous access to shares
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionShares /t REG_MULTI_SZ /d "" /f
}

passchangeREG