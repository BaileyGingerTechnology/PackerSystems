import-module ActiveDirectory


function passchangeAD() {
Get-ADUser -Filter * | ForEach-Object {
Set-ADAccountPassword -Identity $_ -NewPassword (ConvertTo-SecureString -AsPlainText "Asecurepassword123!" -Force)
}
keys
}


function passchangeREG() {
Get-WmiObject win32_useraccount | Foreach-Object {
([adsi](“WinNT://”+$_.caption).replace(“\”,”/”)).SetPassword(“Asecurepassword123!”)
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


#call function below \/ the keys function does need to be explicitly called
